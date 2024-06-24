#!/bin/bash

# Hi
# To execute this script, please enter "bash <name-of-this-file>.sh" in terminal.

# Table of Contents:
# 1.Display your Public IP Address
# 2.Display your Internal IP Address
# 3.Display the Mac address of Machine (Censoring the 1st half)
# 4.Display the Top 5 process' CPU usage percentage
# 5.Display Memory Usage, Total, Used and Free
# 6.Display your active system services and their status
# 7.Locate and display the top 10 files in size, in the "/home" directory
# 8.Space buffer between each mini script
# 9.Finally, load scripts (you can hide unwanted scripts by adding comment marker "#")

# 1.Display your Public IP Address
function my_ipa() {
	echo "[1] Your Public IP Address is:"
	curl -s ifconfig.io
	echo "(Do not share your IP Address on the internet!)"
		#if this doesn't work, try any one of the following:
		#curl -s ifconfig.co
		#curl -s ifconfig.me
		#curl -s ifconfig.il
}

# 2.Display your Internal IP Address
function my_privateip() {
	echo "[2] Your Internal IP Address is:"
	ifconfig | grep broadcast | awk '{print$2}'
		#if this doesn't work, try any one of the following:
		#ip a | grep global | awk '{print$2}'| awk -F/ '{print$1}'
		#ip addr | grep global | awk '{print$2}'| awk -F/ '{print$1}'
		#hostname -I
}

# 3.Display the Mac address of Machine (Censoring the 1st half)
function my_mac() {
	find_mac=$(ifconfig | grep ether | awk '{print$2}')
		#if this doesn't work, try any one of the following:
		#find_mac=$(ip a | grep ether | awk '{print$2}')
		#find_mac=$(ip addr | grep ether | awk '{print$2}')
	censorx="XX:XX:XX"
	echo "[3] Your MAC Address is:"
	echo "$censorx${find_mac:8}"	
		#to see full MAC address:
		#echo $find_mac
}

# 4.Display the Top 5 process’s CPU usage percentage
function my_top5cpu() {
	echo "[4] Computer's Top 5 CPU % usage:"
	echo
	
	#filter to only show User, PID, Command(shortened), CPU%, MEM%
	ps -eo user,pid,cmd,%cpu,%mem --sort=-%cpu | head -n6
	
	#to see full command:
	#ps -p <pid> -o command
}

# 5.Display Memory Usage, Total, Used and Free
function my_memory() {
	echo "[5] Computer's Memory Usage, Total, Used and Free:"
	echo
	
	#use awk to filter only 'tota' 'used' 'free' columns, hide less important columns 'shared' 'buff/cache' 'available'
	free -h | awk -v OFS='\t' 'NR==1{print "",$1,$2,$3;next} {print $1,$2,$3,$4}'
		#reference: https://stackoverflow.com/questions/35564441/how-extract-columns-to-free-command
}

# 6.Display your active system services and their status
function my_services() {
	echo "[6] Your Active System Services:"
	echo

	sudo netstat -tapn
}

# vvv this script is currently NOT working!
# 6-b. extra content.
# command: sudo service xxx status
# choose which service status to view
# function service_info() {

# 	#save all active services in variable, then show list to user
# 	active_services=$(service --status-all | grep '\[ + \]' | awk '{print$4}')
# 	echo "[6-b] Current active services:"
# 	echo "$active_services"
	
# 	#ask user to specify a service
# 	echo "Enter which service's status to display:"
# 	read see_status

# 	#if user input is found within list of active services then
# 	if [[ " ${active_services[*]} " =~ [[:space:]]${see_status}[[:space:]] ]]; then
# 		#output status
# 		sudo service "$see_status" status
# 		echo
# 		echo "Enter 'Next' to stop service status check and go to next check."

# 	#if user input 'Next', will stop asking for input, continue to next section
# 	elif [[ "$see_status" == "Next" ]]; then
# 		#end function, but will not end script
# 		return
	
# 	#if user input is not vaild active service, or 'Next', then show error message
# 	else
# 		echo "This service does not exist, or is not active."
# 	fi
	
# 	#loop this function, so user can check multiple service statuses
# 	service_info
# }

# 7.Locate and display the top 10 files in size, in the "/home" directory
function my_top10files() {
	echo "[7] Your Top 10 largest files in /home directory:"
	echo
	
	#with sudo to allow permissions for other user's directory
	sudo find /home -type f -exec du -h {} + | sort -hr | head -10 
}

# 8.Space buffer between each mini script
function spacer() {
	echo
	#echo "=================================================="		#print a line to separate each mini script
	sleep 1		#wait 1 second between loading each mini script
}

# 9.Finally, load scripts (you can hide unwanted scripts by adding comment marker "#")

	my_ipa
	spacer
	my_privateip
	spacer
	my_mac
	spacer
	my_top5cpu
	spacer
	my_memory
	spacer
	my_services
	spacer
	#service_info #WIP, not working
	#spacer
	my_top10files

# End.
