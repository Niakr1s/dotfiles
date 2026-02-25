-- This should probably not go into the repo, as it's not universally usefull
vim.filetype.add({
  extension = {
    ael = 'ael'
  },
  filename = {
    ['inventory'] = 'dosini',
    ['pjsip.conf'] = 'dosini',
    ['pjsip_wizard.conf'] = 'dosini',
    ['pjsip_wizard.conf.j2'] = 'dosini',
  },
})
