#!/bin/bash

## CleanMojave.sh ##
## A script to unload unnecessary LaunchAgents and LaunchDaemons from MacOS 10.14 ##

################################################"
##        DO NOT RUN THIS SCRIPT BLINDLY       #"
##         YOU'LL PROBABLY REGRET IT...        #"
##                                             #"
##              READ IT THOROUGHLY             #"
##         AND EDIT TO SUIT YOUR NEEDS         #"
################################################"

## run with 'testrun' argument to do a testrun that only echoes commands (bash cleanmojave.sh testrun) ##
## run with 'dontmove' argument to not mv .plist files to .bak (bash cleanmojave.sh dontmove) ##
## run with 'restore' argument to reload daemons (bash cleanmojave.sh restore) ##
## run with 'disable' argument to only disable daemons and not restore unlisted ones (bash cleanmojave.sh disable) ##

## Resources: ##
# https://gist.github.com/pwnsdx/d87b034c4c0210b988040ad2f85a68d3#gistcomment-2701248
# https://github.com/meson10/mac_tej/blob/master/nos.sh
# https://cirrusj.github.io/Yosemite-Stop-Launch/
# https://www.heise.de/mac-and-i/artikel/Die-Systemprozesse-von-macOS-Sierra-3715619.html?seite=all
# http://www.macinside.info/browse.php
# https://www.manpagez.com/man/


## command line flags ##

# restore all #
if [[ " ${@}[*] " == *" restore"* ]]; then
	restore=true
# disable only #
elif [[ " ${@}[*] " == *" disable"* ]]; then
	disableonly=true
fi
# testrun y/n #
if [[ " ${@}[*] " == *" testrun"* ]]; then
	testrun=true
fi
# move plist to .bak y/n #
if [[ " ${@}[*] " == *" dontmove"* ]]; then
	dontmove=true
fi

## Protected Services than can break system while disabling/enabling ##
Protected=(
	/System/Library/LaunchDaemons/com.apple.getty.plist
	)

## LaunchAgents/LaunchDaemons to unload (uncomment): ##
LaunchAgents=(
/System/Library/LaunchAgents/com.apple.accessibility.dfrhud.plist
/System/Library/LaunchAgents/com.apple.AccessibilityVisualsAgent.plist
#/System/Library/LaunchAgents/com.apple.accountsd.plist
/System/Library/LaunchAgents/com.apple.AddressBook.abd.plist #AddressBook Manager
/System/Library/LaunchAgents/com.apple.AddressBook.AssistantService.plist
/System/Library/LaunchAgents/com.apple.AddressBook.ContactsAccountsService.plist
/System/Library/LaunchAgents/com.apple.AddressBook.SourceSync.plist
/System/Library/LaunchAgents/com.apple.AirPlayUIAgent.plist
/System/Library/LaunchAgents/com.apple.AirPortBaseStationAgent.plist
/System/Library/LaunchAgents/com.apple.akd.plist # Auth Kit Framework (iCloud / AppleID related)
#/System/Library/LaunchAgents/com.apple.alf.useragent.plist #application firewall
/System/Library/LaunchAgents/com.apple.AOSHeartbeat.plist
/System/Library/LaunchAgents/com.apple.AOSPushRelay.plist
/System/Library/LaunchAgents/com.apple.ap.adprivacyd.plist # ???
/System/Library/LaunchAgents/com.apple.ap.adservicesd.plist
#/System/Library/LaunchAgents/com.apple.apfsuseragent.plist
#/System/Library/LaunchAgents/com.apple.AppleGraphicsWarning.plist
/System/Library/LaunchAgents/com.apple.appleseed.seedusaged.plist
/System/Library/LaunchAgents/com.apple.appleseed.seedusaged.postinstall.plist
#/System/Library/LaunchAgents/com.apple.applespell.plist #Spelling correction
#/System/Library/LaunchAgents/com.apple.appsleepd.plist
#/System/Library/LaunchAgents/com.apple.appstoreagent.plist
#/System/Library/LaunchAgents/com.apple.appstoreupdateagent.plist
#/System/Library/LaunchAgents/com.apple.askpermissiond.plist
#/System/Library/LaunchAgents/com.apple.AskPermissionUI.plist
#/System/Library/LaunchAgents/com.apple.assertiond.plist
#/System/Library/LaunchAgents/com.apple.AssetCache.agent.plist
#/System/Library/LaunchAgents/com.apple.AssetCacheLocatorService.plist
/System/Library/LaunchAgents/com.apple.assistant_service.plist
/System/Library/LaunchAgents/com.apple.assistantd.plist
/System/Library/LaunchAgents/com.apple.AssistiveControl.plist
#/System/Library/LaunchAgents/com.apple.atsd.useragent.plist # fontd related
#/System/Library/LaunchAgents/com.apple.audio.AudioComponentRegistrar.plist
/System/Library/LaunchAgents/com.apple.avconferenced.plist #Manages communication for FaceTime Calls
#/System/Library/LaunchAgents/com.apple.backgroundtaskmanagementuiagent.plist
/System/Library/LaunchAgents/com.apple.bird.plist # iCloud Drive
/System/Library/LaunchAgents/com.apple.bluetooth.PacketLogger.plist
#/System/Library/LaunchAgents/com.apple.bluetoothUIServer.plist
#/System/Library/LaunchAgents/com.apple.btsa.plist # Bluetooth Setup Assistant
#/System/Library/LaunchAgents/com.apple.cache_delete.plist
#/System/Library/LaunchAgents/com.apple.CalendarAgent.plist
/System/Library/LaunchAgents/com.apple.CallHistoryPluginHelper.plist
/System/Library/LaunchAgents/com.apple.CallHistorySyncHelper.plist
#/System/Library/LaunchAgents/com.apple.cdpd.plist # Keychain related
#/System/Library/LaunchAgents/com.apple.cfnetwork.AuthBrokerAgent.plist
#/System/Library/LaunchAgents/com.apple.cfprefsd.xpc.agent.plist
/System/Library/LaunchAgents/com.apple.cloudd.plist
/System/Library/LaunchAgents/com.apple.cloudpaird.plist
/System/Library/LaunchAgents/com.apple.cloudphotosd.plist
#/System/Library/LaunchAgents/com.apple.cmfsyncagent.plist
#/System/Library/LaunchAgents/com.apple.colorsync.useragent.plist
# /System/Library/LaunchAgents/com.apple.CommCenter-osx.plist # IP Telephony
/System/Library/LaunchAgents/com.apple.commerce.plist
/System/Library/LaunchAgents/com.apple.contacts.donation-agent.plist
/System/Library/LaunchAgents/com.apple.ContactsAgent.plist
#/System/Library/LaunchAgents/com.apple.ContainerRepairAgent.plist
#/System/Library/LaunchAgents/com.apple.controlstrip.plist
#/System/Library/LaunchAgents/com.apple.CoreAuthentication.agent.plist
#/System/Library/LaunchAgents/com.apple.CoreLocationAgent.plist
/System/Library/LaunchAgents/com.apple.coreparsec.silhouette.plist
#/System/Library/LaunchAgents/com.apple.CoreRAIDAgent.plist
#/System/Library/LaunchAgents/com.apple.coreservices.lsactivity.plist
#/System/Library/LaunchAgents/com.apple.coreservices.sharedfilelistd.plist
#/System/Library/LaunchAgents/com.apple.coreservices.UASharedPasteboardProgressUI.plist
#/System/Library/LaunchAgents/com.apple.coreservices.uiagent.plist
#/System/Library/LaunchAgents/com.apple.corespeechd.plist
#/System/Library/LaunchAgents/com.apple.corespotlightd.plist
#/System/Library/LaunchAgents/com.apple.corespotlightservice.plist
#/System/Library/LaunchAgents/com.apple.CryptoTokenKit.ahp.agent.plist
#/System/Library/LaunchAgents/com.apple.csuseragent.plist
#/System/Library/LaunchAgents/com.apple.ctkbind.plist
#/System/Library/LaunchAgents/com.apple.ctkd.plist # Crypto Token Kit
#/System/Library/LaunchAgents/com.apple.cvmsCompAgent3425AMD_i386.plist
#/System/Library/LaunchAgents/com.apple.cvmsCompAgent3425AMD_i386_1.plist
#/System/Library/LaunchAgents/com.apple.cvmsCompAgent3425AMD_x86_64.plist
#/System/Library/LaunchAgents/com.apple.cvmsCompAgent3425AMD_x86_64_1.plist
#/System/Library/LaunchAgents/com.apple.cvmsCompAgent3600_i386.plist
#/System/Library/LaunchAgents/com.apple.cvmsCompAgent3600_i386_1.plist
#/System/Library/LaunchAgents/com.apple.cvmsCompAgent3600_x86_64.plist
#/System/Library/LaunchAgents/com.apple.cvmsCompAgent3600_x86_64_1.plist
#/System/Library/LaunchAgents/com.apple.cvmsCompAgent_i386.plist
#/System/Library/LaunchAgents/com.apple.cvmsCompAgent_i386_1.plist
#/System/Library/LaunchAgents/com.apple.cvmsCompAgent_x86_64.plist
#/System/Library/LaunchAgents/com.apple.cvmsCompAgent_x86_64_1.plist
#/System/Library/LaunchAgents/com.apple.DataDetectorsLocalSources.plist
#/System/Library/LaunchAgents/com.apple.DiagnosticReportCleanup.plist
#/System/Library/LaunchAgents/com.apple.diagnostics_agent.plist
#/System/Library/LaunchAgents/com.apple.DictationIM.plist
#/System/Library/LaunchAgents/com.apple.DiskArbitrationAgent.plist #https://www.manpagez.com/man/8/diskarbitrationd/
#/System/Library/LaunchAgents/com.apple.diskspaced.plist
#/System/Library/LaunchAgents/com.apple.distnoted.xpc.agent.plist
#/System/Library/LaunchAgents/com.apple.dmd.agent.plist
#/System/Library/LaunchAgents/com.apple.Dock.plist
#/System/Library/LaunchAgents/com.apple.dt.CommandLineTools.installondemand.plist
#/System/Library/LaunchAgents/com.apple.DwellControl.plist #Universal Access related
#/System/Library/LaunchAgents/com.apple.eospreflightagent.plist
#/System/Library/LaunchAgents/com.apple.EscrowSecurityAlert.plist
/System/Library/LaunchAgents/com.apple.familycircled.plist
/System/Library/LaunchAgents/com.apple.familycontrols.useragent.plist
/System/Library/LaunchAgents/com.apple.familynotificationd.plist
#/System/Library/LaunchAgents/com.apple.FileProvider.plist
#/System/Library/LaunchAgents/com.apple.FilesystemUI.plist
#/System/Library/LaunchAgents/com.apple.Finder.plist
/System/Library/LaunchAgents/com.apple.findmymacmessenger.plist
#/System/Library/LaunchAgents/com.apple.FolderActionsDispatcher.plist
/System/Library/LaunchAgents/com.apple.followupd.plist
/System/Library/LaunchAgents/com.apple.FollowUpUI.plist
#/System/Library/LaunchAgents/com.apple.fontd.useragent.plist
#/System/Library/LaunchAgents/com.apple.FontRegistryUIAgent.plist
#/System/Library/LaunchAgents/com.apple.FontValidator.plist
#/System/Library/LaunchAgents/com.apple.FontValidatorConduit.plist
#/System/Library/LaunchAgents/com.apple.FontWorker.plist
/System/Library/LaunchAgents/com.apple.gamed.plist
/System/Library/LaunchAgents/com.apple.helpd.plist
/System/Library/LaunchAgents/com.apple.homed.plist # man homed: is a daemon that manages home state and controls HomeKit accessories.
#/System/Library/LaunchAgents/com.apple.icdd.plist #Image Capture Discovery Daemon (For scanners and cameras)
/System/Library/LaunchAgents/com.apple.icloud.findmydeviced.findmydevice-user-agent.plist
/System/Library/LaunchAgents/com.apple.icloud.fmfd.plist
/System/Library/LaunchAgents/com.apple.iCloudUserNotifications.plist
#/System/Library/LaunchAgents/com.apple.iconservices.iconservicesagent.plist
/System/Library/LaunchAgents/com.apple.identityservicesd.plist #
/System/Library/LaunchAgents/com.apple.idsremoteurlconnectionagent.plist # ios remote connection related
/System/Library/LaunchAgents/com.apple.imagent.plist # Face Time Invitation Listener
#/System/Library/LaunchAgents/com.apple.imautomatichistorydeletionagent.plist
#/System/Library/LaunchAgents/com.apple.imklaunchagent.plist
#/System/Library/LaunchAgents/com.apple.imtransferagent.plist
#/System/Library/LaunchAgents/com.apple.installandsetup.migrationhelper.user.plist
#/System/Library/LaunchAgents/com.apple.installd.user.plist
#/System/Library/LaunchAgents/com.apple.installerauthagent.plist
#/System/Library/LaunchAgents/com.apple.isst.plist # -> /System/Library/CoreServices/Menu Extras/TextInput.menu/Contents/SharedSupport/isst
#/System/Library/LaunchAgents/com.apple.iTunesHelper.launcher.plist
/System/Library/LaunchAgents/com.apple.java.InstallOnDemand.plist
#/System/Library/LaunchAgents/com.apple.keyboardservicesd.plist
/System/Library/LaunchAgents/com.apple.knowledge-agent.plist
#/System/Library/LaunchAgents/com.apple.languageassetd.plist
/System/Library/LaunchAgents/com.apple.lateragent.plist # System Update Reminder
#/System/Library/LaunchAgents/com.apple.LocalAuthentication.UIAgent.plist
#/System/Library/LaunchAgents/com.apple.locationmenu.plist
#/System/Library/LaunchAgents/com.apple.loginwindow.LWWeeklyMessageTracer.plist
#/System/Library/LaunchAgents/com.apple.lsd.plist
/System/Library/LaunchAgents/com.apple.macos.studentd.plist
# /System/Library/LaunchAgents/com.apple.ManagedClientAgent.agent.plist
/System/Library/LaunchAgents/com.apple.ManagedClientAgent.enrollagent.plist
/System/Library/LaunchAgents/com.apple.Maps.pushdaemon.plist
#/System/Library/LaunchAgents/com.apple.mbbackgrounduseragent.plist
#/System/Library/LaunchAgents/com.apple.mbfloagent.plist
#/System/Library/LaunchAgents/com.apple.mbuseragent.plist
#/System/Library/LaunchAgents/com.apple.mdmclient.agent.plist
#/System/Library/LaunchAgents/com.apple.mdworker.32bit.plist
#/System/Library/LaunchAgents/com.apple.mdworker.bundles.plist
#/System/Library/LaunchAgents/com.apple.mdworker.mail.plist
#/System/Library/LaunchAgents/com.apple.mdworker.shared.plist
#/System/Library/LaunchAgents/com.apple.mdworker.single.plist
#/System/Library/LaunchAgents/com.apple.mdworker.sizing.plist
#/System/Library/LaunchAgents/com.apple.mediaanalysisd.plist
#/System/Library/LaunchAgents/com.apple.mediaremoteagent.plist #iTunes related
#/System/Library/LaunchAgents/com.apple.metadata.mdbulkimport.plist
#/System/Library/LaunchAgents/com.apple.metadata.mdflagwriter.plist
#/System/Library/LaunchAgents/com.apple.metadata.mdwrite.plist
#/System/Library/LaunchAgents/com.apple.midiserver.plist
/System/Library/LaunchAgents/com.apple.MobileAccessoryUpdater.fudHelperAgent.plist
#/System/Library/LaunchAgents/com.apple.mobiledeviceupdater.plist
/System/Library/LaunchAgents/com.apple.MRTa.plist # Apple Malware Removal Tool / YaraScanService
/System/Library/LaunchAgents/com.apple.navd.plist
#/System/Library/LaunchAgents/com.apple.neagent.plist
#/System/Library/LaunchAgents/com.apple.netauth.user.auth.plist
#/System/Library/LaunchAgents/com.apple.netauth.user.gui.plist
#/System/Library/LaunchAgents/com.apple.networkserviceproxy-osx.plist
/System/Library/LaunchAgents/com.apple.noticeboard.agent.plist
/System/Library/LaunchAgents/com.apple.notificationcenterui.plist
#/System/Library/LaunchAgents/com.apple.NowPlayingTouchUI.plist
#/System/Library/LaunchAgents/com.apple.nsurlsessiond.plist
#/System/Library/LaunchAgents/com.apple.nsurlstoraged.plist
#/System/Library/LaunchAgents/com.apple.NVMeAgent.plist
#/System/Library/LaunchAgents/com.apple.OSDUIHelper.plist
#/System/Library/LaunchAgents/com.apple.PackageKit.InstallStatus.plist
/System/Library/LaunchAgents/com.apple.parentalcontrols.check.plist
/System/Library/LaunchAgents/com.apple.parsec-fbf.plist
/System/Library/LaunchAgents/com.apple.parsecd.plist # man parsecd: manages access and data for Siri Suggestions.
#/System/Library/LaunchAgents/com.apple.passd.plist
#/System/Library/LaunchAgents/com.apple.pboard.plist
#/System/Library/LaunchAgents/com.apple.pbs.plist
#/System/Library/LaunchAgents/com.apple.PCIESlotCheck.plist
/System/Library/LaunchAgents/com.apple.personad.plist
/System/Library/LaunchAgents/com.apple.photoanalysisd.plist
/System/Library/LaunchAgents/com.apple.photolibraryd.plist
/System/Library/LaunchAgents/com.apple.PhotoLibraryMigrationUtility.XPC.plist
#/System/Library/LaunchAgents/com.apple.pictd.plist
#/System/Library/LaunchAgents/com.apple.PIPAgent.plist
#/System/Library/LaunchAgents/com.apple.pluginkit.pkd.plist
#/System/Library/LaunchAgents/com.apple.pluginkit.pkreporter.plist
#/System/Library/LaunchAgents/com.apple.powerchime.plist
#/System/Library/LaunchAgents/com.apple.preference.displays.MirrorDisplays.plist
#/System/Library/LaunchAgents/com.apple.printtool.agent.plist
#/System/Library/LaunchAgents/com.apple.printuitool.agent.plist
#/System/Library/LaunchAgents/com.apple.progressd.plist
/System/Library/LaunchAgents/com.apple.protectedcloudstorage.protectedcloudkeysyncing.plist
#/System/Library/LaunchAgents/com.apple.PubSub.Agent.plist # RSS related
#/System/Library/LaunchAgents/com.apple.quicklook.32bit.plist
#/System/Library/LaunchAgents/com.apple.quicklook.plist
#/System/Library/LaunchAgents/com.apple.quicklook.ThumbnailsAgent.plist
#/System/Library/LaunchAgents/com.apple.quicklook.ui.helper.plist
#/System/Library/LaunchAgents/com.apple.rapportd-user.plist
#/System/Library/LaunchAgents/com.apple.RapportUIAgent.plist
/System/Library/LaunchAgents/com.apple.rcd.plist # Remote Control Daemon
/System/Library/LaunchAgents/com.apple.recentsd.plist # https://www.manpagez.com/man/8/recentsd/
/System/Library/LaunchAgents/com.apple.RemoteDesktop.plist
/System/Library/LaunchAgents/com.apple.ReportCrash.plist
#/System/Library/LaunchAgents/com.apple.ReportCrash.Self.plist
#/System/Library/LaunchAgents/com.apple.ReportGPURestart.plist
#/System/Library/LaunchAgents/com.apple.ReportPanic.plist
#/System/Library/LaunchAgents/com.apple.reversetemplated.plist
#/System/Library/LaunchAgents/com.apple.routined.plist
/System/Library/LaunchAgents/com.apple.Safari.SafeBrowsing.Service.plist
/System/Library/LaunchAgents/com.apple.SafariBookmarksSyncAgent.plist
/System/Library/LaunchAgents/com.apple.SafariCloudHistoryPushAgent.plist
/System/Library/LaunchAgents/com.apple.safaridavclient.plist
/System/Library/LaunchAgents/com.apple.SafariHistoryServiceAgent.plist
/System/Library/LaunchAgents/com.apple.SafariLaunchAgent.plist
/System/Library/LaunchAgents/com.apple.SafariNotificationAgent.plist
/System/Library/LaunchAgents/com.apple.SafariPlugInUpdateNotifier.plist
#/System/Library/LaunchAgents/com.apple.SafeEjectGPUAgent.plist
/System/Library/LaunchAgents/com.apple.scopedbookmarkagent.xpc.plist
#/System/Library/LaunchAgents/com.apple.screencaptureui.plist
#/System/Library/LaunchAgents/com.apple.ScreenReaderUIServer.plist
#/System/Library/LaunchAgents/com.apple.screensharing.agent.plist
#/System/Library/LaunchAgents/com.apple.screensharing.menuextra.plist
#/System/Library/LaunchAgents/com.apple.screensharing.MessagesAgent.plist
#/System/Library/LaunchAgents/com.apple.ScriptMenuApp.plist
#/System/Library/LaunchAgents/com.apple.scrod.plist # Screen Reader
#/System/Library/LaunchAgents/com.apple.secd.plist
#/System/Library/LaunchAgents/com.apple.secinitd.plist
#/System/Library/LaunchAgents/com.apple.security.agent.plist
#/System/Library/LaunchAgents/com.apple.security.cloudkeychainproxy3.plist
#/System/Library/LaunchAgents/com.apple.security.DiskUnmountWatcher.plist
#/System/Library/LaunchAgents/com.apple.security.keychain-circle-notification.plist
#/System/Library/LaunchAgents/com.apple.securityuploadd.plist
#/System/Library/LaunchAgents/com.apple.ServicesUIAgent.plist
/System/Library/LaunchAgents/com.apple.sharingd.plist # https://www.manpagez.com/man/8/sharingd/
/System/Library/LaunchAgents/com.apple.sidecar-relay.plist # Remote Device / Display
/System/Library/LaunchAgents/com.apple.Siri.agent.plist
/System/Library/LaunchAgents/com.apple.siriknowledged.plist
/System/Library/LaunchAgents/com.apple.soagent.plist
/System/Library/LaunchAgents/com.apple.SocialPushAgent.plist
/System/Library/LaunchAgents/com.apple.softwareupdate_notify_agent.plist
/System/Library/LaunchAgents/com.apple.SoftwareUpdateNotificationManager.plist
#/System/Library/LaunchAgents/com.apple.speech.speechdatainstallerd.plist
#/System/Library/LaunchAgents/com.apple.speech.speechsynthesisd.plist
#/System/Library/LaunchAgents/com.apple.speech.synthesisserver.plist
#/System/Library/LaunchAgents/com.apple.spindump_agent.plist
#/System/Library/LaunchAgents/com.apple.Spotlight.plist
#/System/Library/LaunchAgents/com.apple.SSInvitationAgent.plist #ScreenSharing Invitation Agent
#/System/Library/LaunchAgents/com.apple.StorageManagementUIHelper.plist
#/System/Library/LaunchAgents/com.apple.storeaccountd.plist
#/System/Library/LaunchAgents/com.apple.storeassetd.plist
#/System/Library/LaunchAgents/com.apple.storedownloadd.plist
#/System/Library/LaunchAgents/com.apple.storeinstallagent.plist
#/System/Library/LaunchAgents/com.apple.storelegacy.plist
#/System/Library/LaunchAgents/com.apple.storeuid.plist
/System/Library/LaunchAgents/com.apple.suggestd.plist #Seems related to finding contacts in emails
# /System/Library/LaunchAgents/com.apple.swcd.plist #Shared Web Credentials (Safari related)
#/System/Library/LaunchAgents/com.apple.syncdefaultsd.plist # man syncdefaultsd
#/System/Library/LaunchAgents/com.apple.syncservices.SyncServer.plist
#/System/Library/LaunchAgents/com.apple.syncservices.uihandler.plist
#/System/Library/LaunchAgents/com.apple.sysdiagnose_agent.plist
#/System/Library/LaunchAgents/com.apple.systemprofiler.plist
#/System/Library/LaunchAgents/com.apple.SystemUIServer.plist
#/System/Library/LaunchAgents/com.apple.talagent.plist
#/System/Library/LaunchAgents/com.apple.tccd.plist
# /System/Library/LaunchAgents/com.apple.telephonyutilities.callservicesd.plist
#/System/Library/LaunchAgents/com.apple.thermaltrap.plist
#/System/Library/LaunchAgents/com.apple.tiswitcher.plist
#/System/Library/LaunchAgents/com.apple.TMHelperAgent.plist
#/System/Library/LaunchAgents/com.apple.TMHelperAgent.SetupOffer.plist
/System/Library/LaunchAgents/com.apple.touristd.plist
#/System/Library/LaunchAgents/com.apple.trustd.agent.plist
#/System/Library/LaunchAgents/com.apple.TrustEvaluationAgent.plist
#/System/Library/LaunchAgents/com.apple.uikitsystemapp.plist
#/System/Library/LaunchAgents/com.apple.universalaccessAuthWarn.plist
#/System/Library/LaunchAgents/com.apple.universalaccesscontrol.plist
#/System/Library/LaunchAgents/com.apple.universalaccessd.plist
#/System/Library/LaunchAgents/com.apple.universalaccessHUD.plist
#/System/Library/LaunchAgents/com.apple.unmountassistant.useragent.plist
/System/Library/LaunchAgents/com.apple.UsageTrackingAgent.plist # https://www.unix.com/man-page/mojave/8/UsageTrackingAgent/
#/System/Library/LaunchAgents/com.apple.USBAgent.plist
#/System/Library/LaunchAgents/com.apple.UserEventAgent-Aqua.plist
#/System/Library/LaunchAgents/com.apple.UserEventAgent-LoginWindow.plist
#/System/Library/LaunchAgents/com.apple.usernoted.plist
#/System/Library/LaunchAgents/com.apple.UserNotificationCenterAgent-LoginWindow.plist
#/System/Library/LaunchAgents/com.apple.UserNotificationCenterAgent.plist # Handles User Interactions incl. Permission Dialogs
/System/Library/LaunchAgents/com.apple.videosubscriptionsd.plist
#/System/Library/LaunchAgents/com.apple.voicememod.plist
#/System/Library/LaunchAgents/com.apple.VoiceOver.plist
#/System/Library/LaunchAgents/com.apple.warmd_agent.plist
#/System/Library/LaunchAgents/com.apple.webinspectord.plist
#/System/Library/LaunchAgents/com.apple.WebKit.PluginAgent.plist
#/System/Library/LaunchAgents/com.apple.wifi.WiFiAgent.plist
#/System/Library/LaunchAgents/com.apple.WiFiVelocityAgent.plist
#/System/Library/LaunchAgents/com.apple.xpc.loginitemregisterd.plist
#/System/Library/LaunchAgents/com.apple.xpc.otherbsd.plist
)

LaunchDaemons=(
#/System/Library/LaunchDaemons/com.openssh.ssh-agent.plist
#/System/Library/LaunchDaemons/bootps.plist
#/System/Library/LaunchDaemons/com.apple.accessoryd.plist
#/System/Library/LaunchDaemons/com.apple.adid.plist
#/System/Library/LaunchDaemons/com.apple.afpfs_afpLoad.plist
#/System/Library/LaunchDaemons/com.apple.afpfs_checkafp.plist
/System/Library/LaunchDaemons/com.apple.AirPlayXPCHelper.plist
#/System/Library/LaunchDaemons/com.apple.airport.wps.plist
#/System/Library/LaunchDaemons/com.apple.airportd.plist
#/System/Library/LaunchDaemons/com.apple.akd.plist # Auth Kit Framework
#/System/Library/LaunchDaemons/com.apple.alf.agent.plist # Firewall
/System/Library/LaunchDaemons/com.apple.analyticsd.plist
#/System/Library/LaunchDaemons/com.apple.apfsd.plist
#/System/Library/LaunchDaemons/com.apple.AppleFileServer.plist
#/System/Library/LaunchDaemons/com.apple.applefileutil.plist
#/System/Library/LaunchDaemons/com.apple.AppleQEMUGuestAgent.plist
#/System/Library/LaunchDaemons/com.apple.appleseed.fbahelperd.plist
#/System/Library/LaunchDaemons/com.apple.applessdstatistics.plist
/System/Library/LaunchDaemons/com.apple.apsd.plist #Apple Push Notification Service
#/System/Library/LaunchDaemons/com.apple.aslmanager.plist
#/System/Library/LaunchDaemons/com.apple.AssetCache.builtin.plist
#/System/Library/LaunchDaemons/com.apple.AssetCacheLocatorService.plist
#/System/Library/LaunchDaemons/com.apple.AssetCacheManagerService.plist
#/System/Library/LaunchDaemons/com.apple.AssetCacheTetheratorService.plist
#/System/Library/LaunchDaemons/com.apple.atrun.plist
#/System/Library/LaunchDaemons/com.apple.audio.AudioComponentRegistrar.daemon.plist
#/System/Library/LaunchDaemons/com.apple.audio.coreaudiod.plist
#/System/Library/LaunchDaemons/com.apple.audio.systemsoundserverd.plist
#/System/Library/LaunchDaemons/com.apple.auditd.plist
#/System/Library/LaunchDaemons/com.apple.autofsd.plist
#/System/Library/LaunchDaemons/com.apple.automountd.plist
#/System/Library/LaunchDaemons/com.apple.avbdeviced.plist
/System/Library/LaunchDaemons/com.apple.awacsd.plist #Apple Wide Area Connectivity Service daemon - Back to My Mac Feature
/System/Library/LaunchDaemons/com.apple.awdd.plist # system daemon that collects diagnostics and usage data locally for users that have opted in.
#/System/Library/LaunchDaemons/com.apple.backupd-helper.plist
#/System/Library/LaunchDaemons/com.apple.backupd.plist
/System/Library/LaunchDaemons/com.apple.biokitaggdd.plist
/System/Library/LaunchDaemons/com.apple.biometrickitd.plist
# /System/Library/LaunchDaemons/com.apple.bluetoothaudiod.plist
# /System/Library/LaunchDaemons/com.apple.bluetoothd.plist
# /System/Library/LaunchDaemons/com.apple.bluetoothReporter.plist
#/System/Library/LaunchDaemons/com.apple.bnepd.plist
#/System/Library/LaunchDaemons/com.apple.bootinstalld.plist
#/System/Library/LaunchDaemons/com.apple.bosreporter.plist
#/System/Library/LaunchDaemons/com.apple.boswatcher.plist
#/System/Library/LaunchDaemons/com.apple.bridgeOSUpdateProxy.plist
#/System/Library/LaunchDaemons/com.apple.bsd.dirhelper.plist
#/System/Library/LaunchDaemons/com.apple.captiveagent.plist
#/System/Library/LaunchDaemons/com.apple.cfnetwork.cfnetworkagent.plist
#/System/Library/LaunchDaemons/com.apple.cfprefsd.xpc.daemon.plist
#/System/Library/LaunchDaemons/com.apple.cmio.AppleCameraAssistant.plist
#/System/Library/LaunchDaemons/com.apple.cmio.AVCAssistant.plist
#/System/Library/LaunchDaemons/com.apple.cmio.IIDCVideoAssistant.plist
# /System/Library/LaunchDaemons/com.apple.cmio.iOSScreenCaptureAssistant.plist
#/System/Library/LaunchDaemons/com.apple.cmio.VDCAssistant.plist
#/System/Library/LaunchDaemons/com.apple.colorsync.displayservices.plist
#/System/Library/LaunchDaemons/com.apple.colorsyncd.plist
# /System/Library/LaunchDaemons/com.apple.CommCenterRootHelper.plist
/System/Library/LaunchDaemons/com.apple.commerced.plist
/System/Library/LaunchDaemons/com.apple.comsat.plist #server process which receives reports of incoming mail and notifies users if they have requested this service.
#/System/Library/LaunchDaemons/com.apple.configd.plist
#/System/Library/LaunchDaemons/com.apple.configureLocalKDC.plist
#/System/Library/LaunchDaemons/com.apple.contextstored.plist
#/System/Library/LaunchDaemons/com.apple.CoreAuthentication.daemon.plist
#/System/Library/LaunchDaemons/com.apple.corebrightnessd.plist
#/System/Library/LaunchDaemons/com.apple.corecaptured.plist
#/System/Library/LaunchDaemons/com.apple.coreduetd.osx.plist
#/System/Library/LaunchDaemons/com.apple.CoreRAID.plist
#/System/Library/LaunchDaemons/com.apple.coreservices.appleevents.plist
#/System/Library/LaunchDaemons/com.apple.coreservices.launchservicesd.plist
#/System/Library/LaunchDaemons/com.apple.coreservices.sharedfilelistd.plist
#/System/Library/LaunchDaemons/com.apple.coreservicesd.plist
#/System/Library/LaunchDaemons/com.apple.corestorage.corestoraged.plist
#/System/Library/LaunchDaemons/com.apple.corestorage.corestoragehelperd.plist
#/System/Library/LaunchDaemons/com.apple.coresymbolicationd.plist
#/System/Library/LaunchDaemons/com.apple.CrashReporterSupportHelper.plist
#/System/Library/LaunchDaemons/com.apple.CryptoTokenKit.ahp.plist
#/System/Library/LaunchDaemons/com.apple.CSCSupportd.plist
#/System/Library/LaunchDaemons/com.apple.csrutil.report.plist
#/System/Library/LaunchDaemons/com.apple.ctkd.plist
#/System/Library/LaunchDaemons/com.apple.cvmsServ.plist
#/System/Library/LaunchDaemons/com.apple.dasd-OSX.plist
#/System/Library/LaunchDaemons/com.apple.DataDetectorsSourceAccess.plist
#/System/Library/LaunchDaemons/com.apple.defragx.plist
#/System/Library/LaunchDaemons/com.apple.DesktopServicesHelper.plist
#/System/Library/LaunchDaemons/com.apple.diagnosticd.plist # https://eclecticlight.co/2017/10/10/inside-the-macos-log-logd-and-the-files-that-it-manages/
# /System/Library/LaunchDaemons/com.apple.diagnosticextensions.osx.bluetooth.helper.plist
# /System/Library/LaunchDaemons/com.apple.diagnosticextensions.osx.getmobilityinfo.helper.plist
# /System/Library/LaunchDaemons/com.apple.diagnosticextensions.osx.spotlight.helper.plist
# /System/Library/LaunchDaemons/com.apple.diagnosticextensions.osx.timemachine.helper.plist
# /System/Library/LaunchDaemons/com.apple.diagnosticextensions.osx.wifi.helper.plist
#/System/Library/LaunchDaemons/com.apple.diskarbitrationd.plist
#/System/Library/LaunchDaemons/com.apple.diskmanagementd.plist
#/System/Library/LaunchDaemons/com.apple.diskmanagementstartup.plist
#/System/Library/LaunchDaemons/com.apple.displaypolicyd.plist
#/System/Library/LaunchDaemons/com.apple.distnoted.xpc.daemon.plist
#/System/Library/LaunchDaemons/com.apple.dmd.daemon.plist
#/System/Library/LaunchDaemons/com.apple.dnsextd.plist
#/System/Library/LaunchDaemons/com.apple.dpaudiothru.plist
#/System/Library/LaunchDaemons/com.apple.dpd.plist
#/System/Library/LaunchDaemons/com.apple.dprivacyd.plist
#/System/Library/LaunchDaemons/com.apple.driver.eficheck.plist
#/System/Library/LaunchDaemons/com.apple.driver.ethcheck.plist
#/System/Library/LaunchDaemons/com.apple.dspluginhelperd.plist
#/System/Library/LaunchDaemons/com.apple.DumpGPURestart.plist
#/System/Library/LaunchDaemons/com.apple.DumpPanic.plist
#/System/Library/LaunchDaemons/com.apple.dvdplayback.setregion.plist
#/System/Library/LaunchDaemons/com.apple.dynamic_pager.plist
#/System/Library/LaunchDaemons/com.apple.eapolcfg_auth.plist
#/System/Library/LaunchDaemons/com.apple.efilogin-helper.plist
#/System/Library/LaunchDaemons/com.apple.emlog.plist
#/System/Library/LaunchDaemons/com.apple.emond.aslmanager.plist
#/System/Library/LaunchDaemons/com.apple.emond.plist
#/System/Library/LaunchDaemons/com.apple.eoshostd.plist
#/System/Library/LaunchDaemons/com.apple.eppc.plist
/System/Library/LaunchDaemons/com.apple.familycontrols.plist
#/System/Library/LaunchDaemons/com.apple.FileCoordination.plist
/System/Library/LaunchDaemons/com.apple.findmymac.plist
/System/Library/LaunchDaemons/com.apple.findmymacmessenger.plist
#/System/Library/LaunchDaemons/com.apple.firmwaresyncd.plist
#/System/Library/LaunchDaemons/com.apple.fontd.plist
#/System/Library/LaunchDaemons/com.apple.fontmover.plist
#/System/Library/LaunchDaemons/com.apple.FontWorker.plist
#/System/Library/LaunchDaemons/com.apple.fpsd.plist
#/System/Library/LaunchDaemons/com.apple.fseventsd.plist
#/System/Library/LaunchDaemons/com.apple.ftp-proxy.plist
#/System/Library/LaunchDaemons/com.apple.GameController.gamecontrollerd.plist
#/System/Library/LaunchDaemons/com.apple.getty.plist
#/System/Library/LaunchDaemons/com.apple.gkreport.plist
#/System/Library/LaunchDaemons/com.apple.GSSCred.plist
#/System/Library/LaunchDaemons/com.apple.gssd.plist
#/System/Library/LaunchDaemons/com.apple.hdiejectd.plist
#/System/Library/LaunchDaemons/com.apple.hidd.plist
/System/Library/LaunchDaemons/com.apple.icloud.findmydeviced.plist
#/System/Library/LaunchDaemons/com.apple.iconservices.iconservicesagent.plist
#/System/Library/LaunchDaemons/com.apple.iconservices.iconservicesd.plist
#/System/Library/LaunchDaemons/com.apple.IFCStart.plist
#/System/Library/LaunchDaemons/com.apple.ifdreader.plist
#/System/Library/LaunchDaemons/com.apple.installandsetup.systemmigrationd.plist
#/System/Library/LaunchDaemons/com.apple.installd.plist
#/System/Library/LaunchDaemons/com.apple.InstallerDiagnostics.installerdiagd.plist
#/System/Library/LaunchDaemons/com.apple.InstallerDiagnostics.installerdiagwatcher.plist
#/System/Library/LaunchDaemons/com.apple.InstallerProgress.plist
#/System/Library/LaunchDaemons/com.apple.IOAccelMemoryInfoCollector.plist
#/System/Library/LaunchDaemons/com.apple.IOBluetoothUSBDFU.plist
#/System/Library/LaunchDaemons/com.apple.ionodecache.plist
#/System/Library/LaunchDaemons/com.apple.jetsamproperties.Mac.plist
#/System/Library/LaunchDaemons/com.apple.kcproxy.plist
#/System/Library/LaunchDaemons/com.apple.kdumpd.plist
#/System/Library/LaunchDaemons/com.apple.Kerberos.digest-service.plist
#/System/Library/LaunchDaemons/com.apple.Kerberos.kadmind.plist
#/System/Library/LaunchDaemons/com.apple.Kerberos.kcm.plist
#/System/Library/LaunchDaemons/com.apple.Kerberos.kdc.plist
#/System/Library/LaunchDaemons/com.apple.Kerberos.kpasswdd.plist
#/System/Library/LaunchDaemons/com.apple.KernelEventAgent.plist
#/System/Library/LaunchDaemons/com.apple.kextd.plist
#/System/Library/LaunchDaemons/com.apple.kuncd.plist
#/System/Library/LaunchDaemons/com.apple.locate.plist
/System/Library/LaunchDaemons/com.apple.locationd.plist
#/System/Library/LaunchDaemons/com.apple.lockd.plist
#/System/Library/LaunchDaemons/com.apple.logd.plist
#/System/Library/LaunchDaemons/com.apple.logind.plist
#/System/Library/LaunchDaemons/com.apple.loginwindow.plist
#/System/Library/LaunchDaemons/com.apple.logkextloadsd.plist
#/System/Library/LaunchDaemons/com.apple.lsd.plist
/System/Library/LaunchDaemons/com.apple.ManagedClient.cloudconfigurationd.plist
/System/Library/LaunchDaemons/com.apple.ManagedClient.enroll.plist
/System/Library/LaunchDaemons/com.apple.ManagedClient.plist
/System/Library/LaunchDaemons/com.apple.ManagedClient.startup.plist
#/System/Library/LaunchDaemons/com.apple.mbsystemadministration.plist
#/System/Library/LaunchDaemons/com.apple.mbusertrampoline.plist
#/System/Library/LaunchDaemons/com.apple.mdmclient.daemon.plist
#/System/Library/LaunchDaemons/com.apple.mdmclient.daemon.runatboot.plist
#/System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
#/System/Library/LaunchDaemons/com.apple.mDNSResponderHelper.plist
#/System/Library/LaunchDaemons/com.apple.mediaremoted.plist #hangs itunes if disabled
#/System/Library/LaunchDaemons/com.apple.metadata.mds.index.plist
#/System/Library/LaunchDaemons/com.apple.metadata.mds.plist
#/System/Library/LaunchDaemons/com.apple.metadata.mds.scan.plist
#/System/Library/LaunchDaemons/com.apple.metadata.mds.spindump.plist
/System/Library/LaunchDaemons/com.apple.mobile.keybagd.plist # iOS related
#/System/Library/LaunchDaemons/com.apple.MobileAccessoryUpdater.plist
#/System/Library/LaunchDaemons/com.apple.mobileactivationd.plist
#/System/Library/LaunchDaemons/com.apple.mobileassetd.plist
#/System/Library/LaunchDaemons/com.apple.MobileFileIntegrity.plist
/System/Library/LaunchDaemons/com.apple.MRTd.plist # Apple Malware Removal Tool / YaraScanService
#/System/Library/LaunchDaemons/com.apple.msrpc.echosvc.plist
#/System/Library/LaunchDaemons/com.apple.msrpc.lsarpc.plist
#/System/Library/LaunchDaemons/com.apple.msrpc.mdssvc.plist
#/System/Library/LaunchDaemons/com.apple.msrpc.netlogon.plist
#/System/Library/LaunchDaemons/com.apple.msrpc.srvsvc.plist
#/System/Library/LaunchDaemons/com.apple.msrpc.wkssvc.plist
#/System/Library/LaunchDaemons/com.apple.multiversed.plist
#/System/Library/LaunchDaemons/com.apple.nehelper.plist https://www.manpagez.com/man/8/nehelper/
#/System/Library/LaunchDaemons/com.apple.nesessionmanager.plist
#/System/Library/LaunchDaemons/com.apple.netauth.sys.auth.plist
#/System/Library/LaunchDaemons/com.apple.netauth.sys.gui.plist
#/System/Library/LaunchDaemons/com.apple.netbiosd.plist
#/System/Library/LaunchDaemons/com.apple.NetBootClientStatus.plist
#/System/Library/LaunchDaemons/com.apple.NetworkLinkConditioner.plist
#/System/Library/LaunchDaemons/com.apple.NetworkSharing.plist
#/System/Library/LaunchDaemons/com.apple.newsyslog.plist
#/System/Library/LaunchDaemons/com.apple.nfcd.plist
#/System/Library/LaunchDaemons/com.apple.nfrestore.plist
#/System/Library/LaunchDaemons/com.apple.nfsconf.plist
#/System/Library/LaunchDaemons/com.apple.nfsd.plist
/System/Library/LaunchDaemons/com.apple.noticeboard.state.plist #NoticeBoard Framework
#/System/Library/LaunchDaemons/com.apple.notifyd.plist # https://www.manpagez.com/man/8/notifyd/
#/System/Library/LaunchDaemons/com.apple.nsurlsessiond.plist
#/System/Library/LaunchDaemons/com.apple.nsurlstoraged.plist
#/System/Library/LaunchDaemons/com.apple.ocspd.plist
#/System/Library/LaunchDaemons/com.apple.odproxyd.plist # https://www.manpagez.com/man/8/odproxyd/
# /System/Library/LaunchDaemons/com.apple.ODSAgent.plist # Remote Disc Sharing
#/System/Library/LaunchDaemons/com.apple.opendirectoryd.plist
/System/Library/LaunchDaemons/com.apple.osanalytics.osanalyticshelper.plist
#/System/Library/LaunchDaemons/com.apple.PasswordService.plist
#/System/Library/LaunchDaemons/com.apple.PCIELaneConfigTool.plist
#/System/Library/LaunchDaemons/com.apple.PerfPowerServices.plist
#/System/Library/LaunchDaemons/com.apple.PerfPowerServicesExtended.plist
#/System/Library/LaunchDaemons/com.apple.periodic-daily.plist
#/System/Library/LaunchDaemons/com.apple.periodic-monthly.plist
#/System/Library/LaunchDaemons/com.apple.periodic-weekly.plist
#/System/Library/LaunchDaemons/com.apple.pfctl.plist
#/System/Library/LaunchDaemons/com.apple.pfd.plist
/System/Library/LaunchDaemons/com.apple.postfix.master.plist
/System/Library/LaunchDaemons/com.apple.postfix.newaliases.plist
#/System/Library/LaunchDaemons/com.apple.powerd.plist
#/System/Library/LaunchDaemons/com.apple.powerd.swd.plist
#/System/Library/LaunchDaemons/com.apple.preferences.timezone.admintool.plist
#/System/Library/LaunchDaemons/com.apple.printtool.daemon.plist
#/System/Library/LaunchDaemons/com.apple.ProcessPanicReport.plist
#/System/Library/LaunchDaemons/com.apple.racoon.plist #VPN related
# /System/Library/LaunchDaemons/com.apple.rapportd.plist
/System/Library/LaunchDaemons/com.apple.RemoteDesktop.PrivilegeProxy.plist
/System/Library/LaunchDaemons/com.apple.remotemanagementd.plist
/System/Library/LaunchDaemons/com.apple.remotepairtool.plist
# /System/Library/LaunchDaemons/com.apple.ReportCrash.Root.plist
# /System/Library/LaunchDaemons/com.apple.ReportCrash.Root.Self.plist
#/System/Library/LaunchDaemons/com.apple.ReportMemoryException.plist
#/System/Library/LaunchDaemons/com.apple.ReportPanicService.plist
#/System/Library/LaunchDaemons/com.apple.revisiond.plist
#/System/Library/LaunchDaemons/com.apple.RFBEventHelper.plist
#/System/Library/LaunchDaemons/com.apple.rootless.init.plist
#/System/Library/LaunchDaemons/com.apple.rpcbind.plist
#/System/Library/LaunchDaemons/com.apple.rtcreportingd.plist #pancake.apple.com
#/System/Library/LaunchDaemons/com.apple.SafeEjectGPUStartupDaemon.plist
#/System/Library/LaunchDaemons/com.apple.sandboxd.plist
#/System/Library/LaunchDaemons/com.apple.SCHelper.plist
#/System/Library/LaunchDaemons/com.apple.screensharing.plist
#/System/Library/LaunchDaemons/com.apple.scsid.plist
#/System/Library/LaunchDaemons/com.apple.secinitd.plist
#/System/Library/LaunchDaemons/com.apple.security.agent.login.plist
#/System/Library/LaunchDaemons/com.apple.security.authhost.plist
#/System/Library/LaunchDaemons/com.apple.security.FDERecoveryAgent.plist
#/System/Library/LaunchDaemons/com.apple.security.syspolicy.plist
#/System/Library/LaunchDaemons/com.apple.securityd.plist
#/System/Library/LaunchDaemons/com.apple.securityd_service.plist
#/System/Library/LaunchDaemons/com.apple.seld.plist
#/System/Library/LaunchDaemons/com.apple.sessionlogoutd.plist
/System/Library/LaunchDaemons/com.apple.signpost.signpost_reporter.plist # perfomance analysis
# /System/Library/LaunchDaemons/com.apple.smb.preferences.plist
/System/Library/LaunchDaemons/com.apple.smbd.plist
#/System/Library/LaunchDaemons/com.apple.softwareupdate_download_service.plist
#/System/Library/LaunchDaemons/com.apple.softwareupdate_firstrun_tasks.plist
#/System/Library/LaunchDaemons/com.apple.softwareupdated.plist
#/System/Library/LaunchDaemons/com.apple.speech.speechsynthesisd.plist
#/System/Library/LaunchDaemons/com.apple.spindump.plist
#/System/Library/LaunchDaemons/com.apple.startupdiskhelper.plist
# /System/Library/LaunchDaemons/com.apple.statd.notify.plist # NFS stat daemon
#/System/Library/LaunchDaemons/com.apple.storagekitd.plist
#/System/Library/LaunchDaemons/com.apple.storeaccountd.daemon.plist
#/System/Library/LaunchDaemons/com.apple.storeagent.daemon.plist
#/System/Library/LaunchDaemons/com.apple.storeassetd.daemon.plist
#/System/Library/LaunchDaemons/com.apple.storedownloadd.daemon.plist
#/System/Library/LaunchDaemons/com.apple.storeinstalld.plist
#/System/Library/LaunchDaemons/com.apple.storereceiptinstaller.plist
/System/Library/LaunchDaemons/com.apple.SubmitDiagInfo.plist
#/System/Library/LaunchDaemons/com.apple.suhelperd.plist
#/System/Library/LaunchDaemons/com.apple.symptomsd.plist
#/System/Library/LaunchDaemons/com.apple.sysdiagnose.plist
#/System/Library/LaunchDaemons/com.apple.sysdiagnose_helper.plist
#/System/Library/LaunchDaemons/com.apple.syslogd.plist
#/System/Library/LaunchDaemons/com.apple.sysmond.plist
#/System/Library/LaunchDaemons/com.apple.system_installd.plist
#/System/Library/LaunchDaemons/com.apple.systemkeychain.plist
#/System/Library/LaunchDaemons/com.apple.systemstats.analysis.plist
#/System/Library/LaunchDaemons/com.apple.systemstats.daily.plist
#/System/Library/LaunchDaemons/com.apple.tailspind.plist
#/System/Library/LaunchDaemons/com.apple.taskgated-helper.plist
#/System/Library/LaunchDaemons/com.apple.taskgated.plist
#/System/Library/LaunchDaemons/com.apple.tccd.system.plist
#/System/Library/LaunchDaemons/com.apple.testmanagerd.plist
#/System/Library/LaunchDaemons/com.apple.thermald.plist # Thermal management daemon.
#/System/Library/LaunchDaemons/com.apple.timed.plist
#/System/Library/LaunchDaemons/com.apple.timezoneupdates.tzd.plist
/System/Library/LaunchDaemons/com.apple.touchbarserver.plist
#/System/Library/LaunchDaemons/com.apple.trustd.plist
#/System/Library/LaunchDaemons/com.apple.TrustEvaluationAgent.system.plist
#/System/Library/LaunchDaemons/com.apple.tzlinkd.plist
#/System/Library/LaunchDaemons/com.apple.ucupdate.plist
#/System/Library/LaunchDaemons/com.apple.uninstalld.plist
#/System/Library/LaunchDaemons/com.apple.unmountassistant.sysagent.plist
#/System/Library/LaunchDaemons/com.apple.usbd.plist
#/System/Library/LaunchDaemons/com.apple.usbmuxd.plist
#/System/Library/LaunchDaemons/com.apple.UserEventAgent-System.plist
#/System/Library/LaunchDaemons/com.apple.UserNotificationCenter.plist
#/System/Library/LaunchDaemons/com.apple.uucp.plist
#/System/Library/LaunchDaemons/com.apple.var-db-dslocal-backup.plist
#/System/Library/LaunchDaemons/com.apple.vsdbutil.plist
#/System/Library/LaunchDaemons/com.apple.warmd.plist # Controls caches used during startup and login
#/System/Library/LaunchDaemons/com.apple.watchdogd.plist
#/System/Library/LaunchDaemons/com.apple.wifid.plist
#/System/Library/LaunchDaemons/com.apple.wifiFirmwareLoader.plist
#/System/Library/LaunchDaemons/com.apple.wifivelocityd.plist
#/System/Library/LaunchDaemons/com.apple.WindowServer.plist
#/System/Library/LaunchDaemons/com.apple.wirelessproxd.plist
#/System/Library/LaunchDaemons/com.apple.WirelessRadioManager-osx.plist
#/System/Library/LaunchDaemons/com.apple.wwand.plist
#/System/Library/LaunchDaemons/com.apple.xartstorageremoted.plist
#/System/Library/LaunchDaemons/com.apple.xpc.roleaccountd.plist
#/System/Library/LaunchDaemons/com.apple.xpc.smd.plist
#/System/Library/LaunchDaemons/com.apple.xpc.uscwoap.plist
#/System/Library/LaunchDaemons/com.apple.xsan.plist
#/System/Library/LaunchDaemons/com.apple.xsandaily.plist
#/System/Library/LaunchDaemons/com.apple.xscertadmin.plist
#/System/Library/LaunchDaemons/com.apple.xscertd-helper.plist
#/System/Library/LaunchDaemons/com.apple.xscertd.plist
#/System/Library/LaunchDaemons/com.vix.cron.plist
#/System/Library/LaunchDaemons/ntalk.plist
#/System/Library/LaunchDaemons/org.apache.httpd.plist
#/System/Library/LaunchDaemons/org.cups.cups-lpd.plist
#/System/Library/LaunchDaemons/org.cups.cupsd.plist
#/System/Library/LaunchDaemons/org.net-snmp.snmpd.plist
#/System/Library/LaunchDaemons/org.openldap.slapd.plist
/System/Library/LaunchDaemons/org.postfix.master.plist
#/System/Library/LaunchDaemons/ssh.plist
#/System/Library/LaunchDaemons/tftp.plise
)

load() {
	if [[ ! -z $testrun ]]; then
		# echo rename 's/\.bak$//' ${@}
		echo launchctl load -w ${@}
		echo sudo launchctl load -w ${@}
	else
		(set -x;
			launchctl load -w ${@};
			sudo launchctl load -w ${@};
			)
		# grep launchctl list output to check if service is really enabled
		enabled=$(launchctl list | grep $(echo "${service}" | /usr/bin/sed -E 's/.*\/(.*).plist/\1/'))
		enabled=$enabled$(sudo launchctl list | grep $(echo "${service}" | /usr/bin/sed -E 's/.*\/(.*).plist/\1/'))
		if [[ ! -z $enabled ]]; then
			echo "[OK] Service ${@} enabled"
		fi
	fi
}

unload() {
	if [[ ! -z $testrun ]]; then
		echo launchctl unload -w ${@}
		echo sudo launchctl unload -w ${@}
		if [[ -z $dontmove  ]]; then
			echo sudo mv ${@} ${@}.bak
		fi
	else
		(set -x;
			launchctl unload -w ${@};
			sudo launchctl unload -w ${@};
		)
		if [[ -z $dontmove ]]; then
			(set -x;
				sudo mv ${@} ${@}.bak;
			)
		fi
		# grep launchctl list output to check if service is really disabled
		disabled=$(launchctl list | grep -q $(echo "${@}" | /usr/bin/sed -E 's/.*\/(.*).plist/\1/'))
		disabled=$disabled$(sudo launchctl list | grep -q $(echo "${@}" | /usr/bin/sed -E 's/.*\/(.*).plist/\1/'))
		if [[ -z $disabled  ]]; then
			echo "[OK] Service ${@} disabled"
		fi
	fi
}

clean() {
	# working directory function argument #
	dir=${@}
	# list of all Agents/Daemons to disable based on lists above #
	eval blacklist='"${'${dir}'[*]}"'
	# rename all .bak files back to .plist first #
	sudo rename 's/\.bak$//' /System/Library/$dir/*;
	for service in /System/Library/$dir/*; do
		# grep launchctl if the service is already enabled
		enabled=$(launchctl list | grep $(echo "${service}" | /usr/bin/sed -E 's/.*\/(.*).plist/\1/'))
		enabled=$enabled$(sudo launchctl list | grep $(echo "${service}" | /usr/bin/sed -E 's/.*\/(.*).plist/\1/'))
		# print status
		if [[ ! -z $enabled ]]; then
			echo enabled: $service
		elif [[ -z $enabled ]]; then
			echo disabled: $service
		fi
		# unload service if found in $blacklist, not found in $Protected and $restore is unset
		if [[ " ${blacklist} " == *" $service "* && " ${Protected[*]} " != *" $service "* && -z $restore ]]; then
			unload $service
		# load service if it's not found in $blacklist or $Protected, $disableonly is unset and it's not already enabled #
		elif [[ " ${blacklist} " != *" $service "* && " ${Protected[*]} " != *" $service "* && -z $disableonly && -z $enabled ]]; then
			load $service
		fi
done
}

clean LaunchAgents
clean LaunchDaemons
