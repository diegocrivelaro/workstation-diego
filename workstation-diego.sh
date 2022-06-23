#!/usr/bin/env bash

#========================================================================================#
# Scripts to configure my development environment in POP_OS
#
# Creator: https://github.com/diegocrivelaro
# Version: >22.04 LTS
#========================================================================================#

#========================================================================================#
# To run it, just give the following command:
# chmod +x workstation-diego.sh
# ./workstation-diego.sh
#========================================================================================#




#----------------------------------------------------------------------------------------#
# LINKS
## SOFTWARES
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
URL_DISCORD="https://dl.discordapp.net/apps/linux/0.0.18/discord-0.0.18.deb"
URL_MULTIMC="https://files.multimc.org/downloads/multimc_1.6-1.deb"
URL_NVM="https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh"

## FONTS
URL_FIRACODE="https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip"

## GNOME EXTENSIONS
URL_CLIPBOARD_INDICATOR="https://codeload.github.com/Tudmotu/gnome-shell-extension-clipboard-indicator/zip/refs/tags/v42"
URL_VITALS="https://codeload.github.com/corecoding/Vitals/zip/refs/tags/v54.0.4"
URL_OPEN_WEATHER="https://drive.google.com/u/0/uc?id=1t1EAmYzAbE9evLV5JhOUkDHbvIK8dZzw&export=download"
URL_SOUND_INPUT_OUTPUT_DEVICE="https://codeload.github.com/kgshank/gse-sound-output-device-chooser/zip/refs/tags/43"
URL_BLUR_MY_SHELL="https://codeload.github.com/aunetx/blur-my-shell/zip/refs/tags/v39"
#----------------------------------------------------------------------------------------#


#----------------------------------------------------------------------------------------#
# DIRECTORIES
SOFTWARE_FOLDER="$HOME/$USER/Softwares"
GNOME_EXTENSIONS_FOLDER="$HOME/.local/share/gnome-shell/extensions"
FONT_FOLDER="$HOME/.local/share/fonts"
#----------------------------------------------------------------------------------------#


#----------------------------------------------------------------------------------------#
# COLORS
RED='\e[1;91m'
GREEN='\e[1;92m'
YELLOW='\e[1;33m'
BOLD='\e[;1m'
RESET='\e[0m'
#----------------------------------------------------------------------------------------#


#----------------------------------------------------------------------------------------#
# FUNCTION
unlock_apt(){
	sudo rm /var/lib/dpkg/lock-frontend
	sudo rm /var/cache/apt/archives/lock
}

test_internet(){
	if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
		echo -e "${RED}[ERROR] - Sem conexão com a internet. Verifique sua rede.${RESET}"
		exit 1
	else
		echo -e "${GREEN}[INFO] - Conexão estabelecida!${RESET}"
	fi
}

apt_update_upgrade(){
	sudo apt update && sudo apt dist-upgrade -y
}

updating_repositories(){
	sudo apt update -y
}
#----------------------------------------------------------------------------------------#


#----------------------------------------------------------------------------------------#
## INSTALLATIONS LISTS
SOFTWARE_LIST=(
	wget
	snapd
	winff
	gparted
	gufw
	gnome-sushi
	vlc
	git
	lutris
	neofetch
	zsh
)
#----------------------------------------------------------------------------------------#


#----------------------------------------------------------------------------------------#
## .DEB
install_debs(){
	echo -e "${YELLOW}[INFO] - Instalando pacotes .deb${RESET}"
	sleep 6

	mkdir "${SOFTWARE_FOLDER}"
	echo -e "${GREEN}[SUCESSO] - Pasta SOFTWARES criada!${RESET}"
	sleep 6

	wget -c "${URL_GOOGLE_CHROME}" -P "${SOFTWARE_FOLDER}"
	wget -c "${URL_DISCORD}" -P "${SOFTWARE_FOLDER}"
	wget -c "${URL_MULTIMC}" -P "${SOFTWARE_FOLDER}"
	sudo dpkg -i $SOFTWARE_FOLDER/*.deb
	wget -qO- ${URL_NVm} | bash
	echo -e "${GREEN}[SUCESSO] - Todos softwares foram instalados com sucesso!${RESET}"
	sleep 6


	echo -e "${YELLOW}[INFO] - Instalando pacotes do repositório${RESET}"
	sleep 6

	sudo apt --fix-broken install
	sudo apt install --install-recommends winehq-stable
	echo -e "${GREEN}[SUCESSO] - Wine instalado com sucesso!${RESET}"
	sleep 6

	for software in ${SOFTWARE_LIST[@]}; do
		  if ! dpkg -l | grep -q $software; then
    		sudo apt install "$software" -y
    		echo -e "${GREEN}[SUCESSO] - ${software} instalado com sucesso!${RESET}"
    		sleep 2
		else
		  echo -e "${YELLOW}[INFO] - ${software} já está instalado no sistema!${RESET}"
		fi
	done
}
#----------------------------------------------------------------------------------------#


#----------------------------------------------------------------------------------------#
## FLATPAK
install_flatpaks(){
	flatpak install flathub com.obsproject.Studio -y
	flatpak install flathub com.spotify.Client -y
	flatpak install flathub org.gimp.GIMP -y
	flatpak install flathub com.valvesoftware.Steam -y
	flatpak install flathub com.getpostman.Postman -y
	flatpak install flathub com.ticktick.TickTick -y
	flatpak install flathub io.github.Figma_Linux.figma_linux -y
	flatpak install flathub net.ankiweb.Anki -y
	flatpak install flathub com.mojang.Minecraft -y
	flatpak install flathub md.obisidian.Obsidian -y

	echo -e "${GREEN}[SUCESSO] - Flatpaks instalados com sucesso!${RESET}"
	sleep 6
}
#----------------------------------------------------------------------------------------#


#----------------------------------------------------------------------------------------#
## SNAP
install_snap(){
	sudo snap install code --classic
	sudo snap install gitkraken --classic
	sudo snap install authy
	sudo snap install telegram-desktop
	sudo snap install slack

	echo -e "${GREEN}[SUCESSO] - Snaps instalados com sucesso!${RESET}"
	sleep 6
}
#----------------------------------------------------------------------------------------#


#----------------------------------------------------------------------------------------#
## INSTALL GNOME-EXTENSIONS
install_gnome_extensions(){
	echo -e "${YELLOW}[INFO] - Instalando extenções do GNOME${RESET}"

  ### Clipboard Indicator
  install_clipboard_indicator(){
    wget -c ${URL_CLIPBOARD_INDICATOR} -P ${GNOME_EXTENSIONS_FOLDER}
    cd ${GNOME_EXTENSIONS_FOLDER}
    unzip v42
    rm -rf v42
    mv gnome-shell-extension-clipboard-indicator-42 clipboard-indicator@tudmotu.com
		gnome-extensions enable clipboard-indicator@tudmotu.com

		echo -e "${GREEN}[SUCESSO] - Extensão Clipboard Indicator instalada com sucesso!${RESET}"
  }

 	install_vitals(){
		wget -c ${URL_VITALS} -P ${GNOME_EXTENSIONS_FOLDER}
		cd ${GNOME_EXTENSIONS_FOLDER}
		unzip v54.0.4
    rm -rf v54.0.4
    mv Vitals-54.0.4 Vitals@CoreCoding.com
    gnome-extensions enable Vitals@CoreCoding.com

		echo -e "${GREEN}[SUCESSO] - Extensão Vitals instalada com sucesso!${RESET}"
	}

	install_open_weather(){
		wget -c ${URL_OPEN_WEATHER} -P ${GNOME_EXTENSIONS_FOLDER}
    cd ${GNOME_EXTENSIONS_FOLDER}
    unzip "uc?id=1t1EAmYzAbE9evLV5JhOUkDHbvIK8dZzw&export=download"
    rm -rf "uc?id=1t1EAmYzAbE9evLV5JhOUkDHbvIK8dZzw&export=download"
    gnome-extensions enable openweather-extension@jenslody.de

    echo -e "${GREEN}[SUCESSO] - Extensão OpenWeathe instalada com sucesso!${RESET}"
	}

	install_sound_input_output_device(){
		wget -c ${URL_SOUND_INPUT_OUTPUT_DEVICE} -P ${GNOME_EXTENSIONS_FOLDER}
		cd ${GNOME_EXTENSIONS_FOLDER}
		unzip 43
    rm -rf 43
    cd gse-sound-output-device-chooser-43
    mv -f sound-output-device-chooser@kgshank.net ${GNOME_EXTENSIONS_FOLDER}
    cd ..
    rm -rf gse-sound-output-device-chooser-43
    mv sound-output-device-chooser@kgshank.net sound-output-device-chooser@kgshank.net
    gnome-extensions enable sound-output-device-chooser@kgshank.net

    echo -e "${GREEN}[SUCESSO] - Extensão Sound Input & Output Device Chooser instalada com sucesso!${RESET}"
	}

	install_blur_my_shell(){
		wget -c ${URL_BLUR_MY_SHELL} -P ${GNOME_EXTENSIONS_FOLDER}
		cd ${GNOME_EXTENSIONS_FOLDER}
		unzip blur-my-shell@aunetx.shell-extension -d blur-my-shell@aunetx
    rm -rf blur-my-shell@aunetx.shell-extension.zip
    gnome-extensions enable blur-my-shell@aunetx

    echo -e "${GREEN}[SUCESSO] - Extensão Blur my Shell instalada com sucesso!${RESET}"
	}

  ### Run
  install_clipboard_indicator
	install_vitals
	install_open_weather
	install_sound_input_output_device
	install_blur_my_shell
  killall -3 gnome-shell
}
#----------------------------------------------------------------------------------------#


#----------------------------------------------------------------------------------------#
## INSTALL FONTS
install_fonts(){
		echo -e "${YELLOW}[INFO] - Instalando fontes${RESET}"

		wget -c "${URL_FIRACODE}" -P "${FONT_FOLDER}"
		cd $FONT_FOLDER
		unzip Fira_Code_v6.2.zip
		rm -rf variable_ttf woff woff2 fira_code.css Fira_Code_v6.2.zip README.txt specimen.html
		cp ttf/*ttf ./
		rm -rf ttf

		echo -e "${GREEN}[SUCESSO] - Fontes instaladas com sucesso!${RESET}"
}
#----------------------------------------------------------------------------------------#


#----------------------------------------------------------------------------------------#
## SYSTEM CLEAN
system_clean(){
	apt_update_upgrade
	flatpak update -y
	sudo apt autoclean -y
	sudo apt autoremove -y
	nautilus -q
}
#----------------------------------------------------------------------------------------#


#----------------------------------------------------------------------------------------#
## EXTRAS
# Adicionar listas de extenções do VSCode
echo "Yarn"
echo "User Themes - Extensão"
echo "Sweet - Theme"
echo "ZSH"
echo "Oh My ZSH"
echo "SpaceShip Themes"
echo "zsh-autosuggestions"


#----------------------------------------------------------------------------------------#




#----------------------------------------------------------------------------------------#
#----------------------------------------EXECUTION---------------------------------------#
unlock_apt
test_internet
unlock_apt
apt_update_upgrade
unlock_apt
updating_repositories
install_debs
install_flatpaks
install_snap
install_gnome_extensions
install_fonts

apt_update_upgrade
system_clean

echo -e "${GREEN}[SUCESSO] - Script finalizado!${RESET}"
