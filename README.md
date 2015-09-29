# Vim Ginkgo Runner

Ginkgo test runner for Vim (with focus support).

## Installation

Install via [vundle](https://github.com/gmarik/vundle):

    Plugin 'jaisonerick/vim-ginkgo-runner'

## Configuration

### Key mappings

Add your key mappings to `.vimrc`:

    map <Leader>t :call RunCurrentGinkgoFile()<CR>
    map <Leader>s :call RunNearestGinkgo()<CR>
    map <Leader>l :call RunLastGinkgo()<CR>
    map <Leader>a :call RunAllGinkgo()<CR>

### Custom command

Overwrite the `g:ginkgo_command` variable to execute a custom command. I use it
together with the
[vim-tmux-runner](https://github.com/christoomey/vim-tmux-runner) plugin to run
the tests on a separate TMux split.

Example:

    let g:ginkgo_command = "call VtrSendCommand('ginkgo {spec}')"

## Credits

This plugin is strongly based on https://github.com/thoughtbot/vim-rspec.
