#!/bin/sh

echo "#!/bin/sh" >> /bin/metamacs
echo 'emacs --daemon' >> /bin/metamacs
echo 'emacsclient --create-frame --alternate-editor=""' >> /bin/metamacs
chmod +x /bin/metamacs

rm -f ~/.emacs.d/init.el
curl -o ~/.emacs.d/init.el https://raw.githubusercontent.com/bently0602/Metamacs/main/init.el

echo 'Done!'
echo 'metamacs is the new command'
