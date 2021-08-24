---
title: 'Backdrop for OS X'
layout: post
color: '#4b2c64'

panel: 'projects/backdrop/panel.jpg'
---

<!--<figure class="hero fixed" data-theme="dark" data-spread="half">
  <picture>
    <img class="sizable" src="https://unsplash.com/photos/E7q00J_8N7A/download" />
  </picture>
</figure>-->

The desktop. It's a thing that you could be potentially staring at all day, depending on how productive you're feeling. It's important that it looks good, probably.

Backdrop is a compact utility application randomly changes your desktop background wallpaper to a new photograph, sourced from [Unsplash](https://unsplash.com/ "Unsplash"). You can activate this by triple clicking anywhere on your desktop. This can be repeated until you find that perfect photograph. The [source code is available on GitHub](https://github.com/arron-jeffery/backdrop "Link to the source code, hosted on GitHub") if you wish to compile the project yourself, alternatively you can download a precompiled .app on [Backdrop's GitHub Pages](http://arron-jeffery.github.io/backdrop) website.


### Triple-Tap Gestures
Backdrop attempts to stay unobtrusive by reducing it's interface to only the bare essentials, making it invisible to the user until they decide to use it. Activating a change of wallpaper requires a triple-tap of the desktop, which is achieved by asynchronously monitoring global `NSEvent` messages and then comparing the target handler for that specific click

<figure class="full-image">
  <picture>
    <img src="{% asset_path "projects/backdrop/cover.jpg" %}" />
  </picture>
</figure>

## Frequently Asked Questions

### Where are downloaded photographs stored? I'd like to find a previous photo that I used.
  All photographs are stored in your 'Pictures' folder, more specifically `~/Pictures/Backdrop Downloads/` so that you can easily retrieve previously used wallpapers. Each file has a label that describes the name of the author, and it's photograph ID. Use the Finder to sort by 'Date Created' to see your history.

### What are the minimum requirements? Do I need any additional libraries or dependencies?
  Backdrop was developed, and is compatible with OS X El Capitan. Backwards-compatibility with older versions of OS X is currently under consideration, but to ensure that (word for minimizing bugs), El Capitan is the minimum requirement for Backdrop.

### Are there any limits for how many photographs I can download?
  According to the [Unsplash API](https://unsplash.com/documentation#rate-limiting), you may download a maximum of 100 photographs each hour, however this is subject to change at any time. If you grab a copy of the source code and compile it using a new Application ID then you could extend this.

### How to I ensure that Backdrop stays running in the background?
  Backdrop has an option to automatically launch on system startup, which can be enabled or disabled in the 'Settings' panel. Otherwise, once you close the initial window, the App should stay running in the background. ⌘Q also prompts the user to decide wether to quit, or just hide.

### How do I uninstall this App?
  Removing Backdrop is pretty simple, you just need to drag the `Backdrop.app` bundle in your Applications folder into the trash. If you've checked  

### Can I help contribute to the development of this utility?
  Of course! Do you use GitHub? Any neat-o ideas you could add to the broth? You may initiate a pull request, otherwise you can just [email me here](mailto:imarronjeffery@me.com?subject=I'd like to contribute to Backdrop!). Thanks!
