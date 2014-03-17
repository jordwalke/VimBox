VimBox
------

> Clean and Simple MacVim Editing

<table>
<tr>
<td>
<img src=".vim/images/VimBox.png" height=256 width=256 />
</td>
<td>
<ul>
  <li><h4>Mac Keyboard mappings</h4></li>
  <li><h4>Familiar autocomplete behavior</h4></li>
  <li><h4>JavaScript indentation lint support</h4></li>
  <li><h4>Snippets (with JavaScript examples)</h4></li>
</ul>
</td>
</tr>
</table>


Installation:
-------------
> Quickly try VimBox in place of your existing setup. Instructions include steps for backing up your existing setup (but you should already have your vim setup under revision control.)

1. Install HomeBrew if needed.

         http://brew.sh/

2. Install MacVim with lua/python support using HomeBrew:

        # Move any existing MacVim.app out of the way.
        mv /Applications/MacVim.app /Applications/MacVim_Backup.app
        brew install macvim --with-cscope --with-lua --python --HEAD
        brew linkapps    # Put the app in your /Applications directory

3. Back up your old .vim folder/files

        mv ~/.vim/ ~/.vim_backup/
        mv ~/.vimrc/ ~/.vimrc_backup/
        mv ~/.gvimrc/ ~/.gvimrc_backup/

4. Clone `VimBox` wherever you like to keep your github clones

        # cd ~/github/     # Or wherever you like to keep github clones
        git clone https://github.com/jordwalke/VimBox/
        ln -s ~/.vim ./VimBox/.vim   # Link to the clone
        ln -s ~/.vimrc ./VimBox/.vimrc
        ln -s ~/.gvimrc ./VimBox/.gvimrc

5. Install NeoBundle:

       ```
       mkdir -p ~/.vim/bundle
       git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
       # Then open Vim/MacVim and run:
       ```

6. Open MacVim and run:

        :NeoBundleInstall
       

Optional Install:
-----------------
       
1. Install vim-airline font:

        open Fonts/Inconsolata-dz+for+Powerline.otf
        # Click "Install Font"

2. Install node.js if you want JS features such as linting (http://nodejs.org/)


