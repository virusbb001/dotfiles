import * as React from "react";
import * as Oni from "oni-api";

export const activate = (oni: Oni.Plugin.Api) => {
  oni.input.unbind("<c-g>") // make C-g work as expected in vim
  oni.input.unbind("<c-v>") // make C-v work as expected in vim
  oni.input.bind("<s-c-g>", () => oni.commands.executeCommand("sneak.show")) // You can rebind Oni's behaviour to a new keybinding
}

export const configuration = {
  activate,
  "oni.loadInitVim"          : true, // Load user's init.vim
  "oni.useDefaultConfig"     : false, // Do not load Oni's init.vim
  "ui.colorscheme"           : "n/a", // Load init.vim colorscheme, remove this line if wants Oni's default
  "autoClosingPairs.enabled" : false, // disable autoclosing pairs
  "commandline.mode"         : false, // Do not override commandline UI
  "wildmenu.mode"            : false, // Do not override wildmenu UI,
  "statusbar.enabled"        : false, // use vim's default statusline
  "sidebar.enabled"          : false, // sidebar ui is gone
  "sidebar.default.open"     : false, // the side bar collapse 
  "learning.enabled"         : false, // Turn off learning pane
  "achievements.enabled"     : false, // Turn off achievements tracking / UX
  "editor.typingPrediction"  : false, // Wait for vim's confirmed typed characters, avoid edge cases
  "editor.textMateHighlighting.enabled" : false, // Use vim syntax highlighting
  "editor.fontSize": "14px",
  "editor.fontFamily": "Consolas,Inconsolata,Noto Sans Mono CJK JP, Monaco",
  "editor.scrollBar.visible": false,
  "editor.scrollBar.cursorTick.visible": false,
}
