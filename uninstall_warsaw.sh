#!/bin/bash

echo "Removing certificates..."
security delete-certificate -c "127.0.0.1" -t /Library/Keychains/System.keychain
security delete-certificate -c "Warsaw Personal CA" -t /Library/Keychains/System.keychain
echo ""

echo "Stopping services..."
launchctl unload /Library/LaunchDaemons/com.diebold.warsaw.plist
for usr_profile in $(ls -1 /Users)
do
  su -l $usr_profile -c 'launchctl unload -w -F -S Aqua ~/Library/LaunchAgents/com.diebold.warsaw.user.plist'
done
sleep 1s
/usr/local/bin/warsaw/uninstall_core
sleep 1s
killall core
sleep 3s
echo ""

echo "Removing files..."
rm -fv /Library/LaunchDaemons/com.diebold.warsaw.plist
rm -fv "/Library/Fonts/Warsaw Bold.ttf"
for user_name in $(who | cut -d' ' -f1 | sort | uniq)
do
  rm -fv /Users/$user_name/Library/LaunchAgents/com.diebold.warsaw.user.plist
done
rm -rfv /usr/local/etc/warsaw
rm -rfv /usr/local/lib/warsaw
rm -rfv /usr/local/bin/warsaw
rm -rfv /tmp/wi*
rm -rfv /tmp/boost_interprocess
rm -rfv /private/tmp/wi*
rm -rfv /private/tmp/boost_interprocess
rm -fv /WS_*
echo ""

echo "Removing package..."
pkgutil --forget com.diebold.warsaw
echo ""

echo "Done."

exit 0
