#!/bin/sh

#  install.sh
#  iSstp
#
#  Created by Zheng Shao on 2/26/15.
#  Copyright (c) 2015 axot. All rights reserved.

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR

sudo chmod 4755 helper
sudo chown root helper
sudo touch installed