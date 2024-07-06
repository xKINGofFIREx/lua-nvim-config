local config = {
    cmd = {'C:/Users/artem/AppData/Local/nvim-data/mason/packages/jdtls/bin/jdtls.bat'},
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
}
require('jdtls').start_or_attach(config)
