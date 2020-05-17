#!/bin/bash
#
# Credit: Franklin Souza
# Telegram: @FranklinTech
#
# Verificar o acesso à internet:
net(){
      ping -w1 192.168.0.1 >/dev/null 2>&1
         while [ $? != 0 ]; do
               echo -e "\e[1;40;31m Sem conexão com à internet!!!"
                     ping -w1 192.168.0.1 >/dev/null 2>&1
         done
      echo ""
      echo -e "\e[1;40;32m Com conexão com à internet!!!"
      sleep 8
}
net
