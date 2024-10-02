
### THIS PROJECT HAS REACHED END OF LIFE
### NO FURTHER SUPPORT WILL BE PROVIDED


![Patched Sur](https://raw.githubusercontent.com/Ben216k/Patched-Sur/main/Extra%20Files/banner400.png)

## What is Patched Sur?

Patched Sur is a UI patcher for macOS Big Sur, designed to make it easy to run macOS 11 on unsupported Macs. This patcher hopes to allow any user of any knowledge to patch their Mac, while still giving you freedom on how you want to use your Mac.

## Compatibility
Anything 2012 or 2013 that's not a Mac Pro. 
- Older -> Use a different patcher.
- Newer -> You support Big Sur.

## Credits

Patched Sur isn't just by me (Ben), **I mostly put it all together and made it easier for people to use it**, several other people have contributed to the patcher and the patches making this what it is today!

- [barrykn](https://github.com/barrykn/): Made the micropatcher that introduced me to the patching process and restored my faith in my really old computer. He also helped pull together a lot of the patches used in this patcher.
- [ASentientBot](https://asentientbot.github.io/) and [MykolaG](https://github.com/khronokernel) for pre-802.11ac WiFi patches (and EduCovas for alerting me of them).
- [ASentientBot](https://asentientbot.github.io/): Made the Hax patches for the installer and brought GeForce Tesla (9400M/320M) framebuffer to Big Sur.
- [jackluke](https://forums.macrumors.com/members/jackluke.1133911/): Figured out how to bypass compatibility checks on the installer USB.
- [highvoltage12v](https://forums.macrumors.com/members/highvoltage12v.883629/): Made the first WiFi kexts used with Big Sur
- [ParrotGeek](https://parrotgeek.com/): developed the LegacyUSBInjector kext to get USB ports working on some older Macs and figuring out a way to skip the terminal commands when opening the installer app on the USB.
- [testheit](https://forums.macrumors.com/members/testheit.1133139/): Helped with the kmutil command in the micropatcher (that is used in Patched Sur too)
- [Ausdauersportler](https://github.com/Ausdauersportler): Integrated patches for iMac Metal GPU support.
- [StarPlayrX](https://github.com/starplayrx/): Pointed out startosinstall which was later used in the patcher to allow macOS updating support without a USB.
- [ASentientHedgehog](https://github.com/moosethegoose2213/): Helped randomly along the way
- [dosdude1](http://dosdude1.com/): OpenGL/GPUSupport swap and of course his patchers which have helped with unsupported Macs patching even in Big Sur.
- Bweesh, Bruno Rocha, NickP0is0n, Noah Fetz, duke4e, riiveraluis, Dead_K1ller, and manthos03 for translating the app.
- [John_val](https://www.reddit.com/user/John_val), [fromeister2009](https://www.reddit.com/user/fromeister2009), [Mr. Macintosh](https://mrmacintosh.com/), [Emperor Epitaph](https://www.youtube.com/channel/UCxGV-Up88t5D4CpcvLS43lw), [Finder352](https://www.youtube.com/channel/UC1ANuAzvOToCVizzck3JjPg), [Monkiey](https://twitter.com/Monkiey2) and [8itCat](https://github.com/8itCat/) for testing some of the new features before release, and pointing out the bugs with them.
- and several others who helped with making Big Sur run as great as it does on unsupported Macs.

Patched Sur also uses two Open Source frameworks, Files and ShellOut by JohnSundell (MIT License), to help handle certain tasks.

## FileVault Warning 
**You must Turn FileVault Off before using Patched Sur**

The patcher shouldn't let you upgrade anyway, but it's good to make sure it's off.

Also, know that turning it on after the upgrade isn't a smart idea. By doing that, you're preventing yourself from recovering your patched Mac in a lot of cases. 

## How do I use Patched Sur?

**1.** Download Patched Sur, (.dmg not .zip), from the GitHub releases page.

**2.** Open the dmg file, right click on the app, and click open.

**3.** The first three prompts are just information explaining the following:
   - A quick intro into Patched Sur
   - How much functionality you will get out of macOS once the patching process is complete
   - How the patcher works, and what it does to your Mac

**4.** After that, your Mac will start downloading the patches for kexts and a couple other resources.

**5.** Now, you will be able to choose what version of macOS to download. By default it will show the latest version available, but if you click `Browse` you can use your own downloaded InstallAssistant.pkg or Install macOS Big Sur.app.

**6.** Once the download is finished, you need to enter your password, so Patched Sur can install the package. Then, after you select the USB drive you want to use to install macOS, the patcher will copy the installer onto the USB.

**7.** Finally, the USB gets patched and you are ready to start installation!

**8.** Reboot your computer, but immediately start holding down the `Option/Alt` key as soon as your Mac turns on.

**9.** Select the __purple__ EFI Boot drive, (if there are multiple unplug and replug in your drive and select the EFI Boot that disappeared and reappeared).  Then, your Mac will quickly turn off, so turn it back on while, again, holding down `Option/Alt`. Then, select Install macOS Big Sur.

**10.** Once the installer boots, select reinstall macOS and agree to the Terms and Conditions. Then, select the drive you want to install Big Sur onto (usually Macintosh HD).

**NOTE:** If you're choosing to do a clean install, restart back into the installer after the Setup Assistant pops up. Then select Patched Sur, select your boot drive, and patch the kexts. Restart into Big Sur, setup your Mac, and ignore the rest of these instructions.

**11.** After the installer is done, (it will take a while and probably appear to get stuck, that's just macOS), log in to your Mac and open Patched Sur from your Applications folder or LaunchPad.

**12.** Open the Patch Kexts section and enter your password. Then, you should be able to reboot and enjoy Big Sur!

#### How do I choose a my own installer?

To choose a different installer that you already have downloaded, click `View Other Versions`. Then, click `Find an Installer` and navigate to the InstallAssistant.pkg or Install macOS Big Sur.app file you would like to use.

#### How would I update macOS? (Starting in v0.1.0+)

To update macOS, follow the steps below.

**1.** Launch the post-install app and click `Update macOS`.

**2.** Select the version you want to update to, (the latest version should be pre-selected).

**3.** Once it finishes downloading the package, it will prompt you to install which will restart your computer after a little bit.

**4.** After the update finishes, open the post install app and patch your kexts.

**5.** Enjoy the latest version of macOS!

Note: Apple does not always release InstallAssistant.pkgs for the beta tracks and some minor updates, this means you might be unable to get certain upates.

## Support

I am a living, breathing human, so don't expect me to respond right away to everything. However, if you need support with the patcher, feel free to open an issue or discussion here (please search the issue list before making a new one) or use one of the links below!

[216k Labs Discord](https://discord.gg/2DxVn4HDX6) (My official discord server for Patched Sur and my more recent projects)

[r/BigSurPatcher Subreddit](https://www.reddit.com/r/BigSurPatcher/) (Not very active, good luck)
