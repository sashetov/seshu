#!/bin/bash
umount /dev/home-data-backup/bkp--server-es && 
  umount /dev/mapper/home--data--backup-bkp----work && 
  umount /dev/mapper/home--data--backup-bkp----android &&
  umount /dev/mapper/home--data--backup-bkp----pics &&
  umount /dev/mapper/home--data--backup-bkp----music &&
  umount /dev/mapper/home--data--backup-bkp----reading &&
  umount /dev/mapper/home--data--backup-bkp----data--root
