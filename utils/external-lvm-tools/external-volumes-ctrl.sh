#!/bin/bash
action=$1
vg_name='';
lv_name='';
scsi_dev=''
if [[ $# -lt 2 ||  $# -gt 2  || ( $action != "activate" && $action != "deactivate" ) ]]; then {
  echo BAD CMD ARGS:
  echo    $0 $*;
  echo USAGE:
  echo './external-volumes-ctrl.sh [ activate | deactivate ] /dev/sdb'
  echo EXAMPLES:
  echo './external-volumes-ctrl.sh activate external-vg-001';
  echo './external-volumes-ctrl.sh deactivate /dev/external-vg-001/external-backup-001';
  exit 1;
}; fi
exit 0;
function is_path_block_special {
  local lvpath=$1;
  if [ -b $lvpath  ] ; then {
    return 0;
  }
  else {
    return 2;
  } fi;
};
function set_vg_and_lv_name_vars_from_lvpath {
  local lvpath=$1;
  vg_and_lv=`sudo lvs $lvpath | tail -n 1 | awk '{ print $2;  print $1; }'`;
  if [ `echo $vg_and_lv | wc -w` -eq 2 ]; then {
    vg_name=`echo $vg_and_lv | cut -d ' ' -f 1`;
    lv_name=`echo $vg_and_lv | cut -d ' ' -f 2`;
    return 0;
  }; else {
    return 3;
  }; fi;
}
function get_scsi_dev_from_vg_name {
  local vgname=$1;
  devices=`sudo pvs | grep $vgname | awk {' print $1; '} | sed -r 's/[0-9]+//g';`;
  if [ `echo $devices | wc -w` -ne 1 ]; then { 
    return 4;
  };
  else {
    scsi_dev=$devices;
  }; fi;
  return 0;
}
function attempt_umount_all_vg_lvs {
  vg_name=$1
  for lv in /dev/$vg_name/*; do {
    echo sudo umount $lv;
    sudo umount $lv;
    if [ $? -ne 0 ]; then {
      echo "Could not unmount $lv ..."
      echo "  0utput from lsof:"
      echo "lsof $lv"
      sudo lsof $lv;
      return 5;
    }; fi;
  }; done;
  return 0;
}
function deactivate_mounted_lv {
  lv_path=$1;
  is_path_block_special $lv_path;
  block_spec_status=$?
  if [ $block_spec_status != 0 ]; then {
    return $block_spec_status;
  }; fi;
  set_vg_and_lv_name_vars_from_lvpath $lv_path;
  set_name_status=$?;
  if [ $set_name_status != 0 ]; then {
    return $set_name_status;
  }; fi;
  get_scsi_dev_from_vg_name $vg_name;
  scsi_dev_status=$?;
  if [ $set_name_status != 0 ]; then {
    return $scsi_dev_status;
  }; fi;
  echo attempting umount of all lvs in $vg_name
  attempt_umount_all_vg_lvs $vg_name
  echo attempting lvchange -an for $vg_name
  sudo lvchange -an /dev/$vg_name
  echo attempting vgexport -a for all vgs not active
  sudo vgexport -a
  echo attempting sdparm -C stop $scsi_dev
  sudo sdparm -C stop $scsi_dev
}
function activate_lvs_in_vg {
  vgname=$1
  echo attempting vgimport -a:
  sudo vgimport -a
  vgactivate_status=$?;
  if [ $vgactivate_status != 0 ]; then {
    return $vgactivate_status;
  }; fi;
  echo attempting  lvchange -ay /dev$/vgname
  sudo lvchange -ay /dev/$vgname
  lvchange_status=$?;
  if [ $lvchange_status != 0 ]; then {
    return $lvchange_status;
  }; fi;
  return 0;
}
if [ $action == "deactivate" ]; then {
  lv_path=$2
  deactivate_mounted_lv $lv_path;
};
else {
  vg_name=$2
  activate_lvs_in_vg $vg_name;
}; fi;
exit $?
