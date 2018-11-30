#!/bin/bash
mount -o rw,user /dev/home-data-backup/bkp--data-root /mnt/data/ &&
mount -o rw,user /dev/home-data-backup/bkp--work /mnt/data/work/ &&
mount -o rw,user /dev/home-data-backup/bkp--server-es /mnt/data/work/paragon/projects/cloudstats/cloudstats-backend/jenkins-puppetization/server-es--backups &&
mount -o rw,user /dev/home-data-backup/bkp--android /mnt/data/android/ &&
mount -o rw,user /dev/home-data-backup/bkp--pics /mnt/data/pics/ &&
mount -o rw,user /dev/home-data-backup/bkp--music /mnt/data/music/ &&
mount -o rw,user /dev/home-data-backup/bkp--reading /mnt/data/reading
