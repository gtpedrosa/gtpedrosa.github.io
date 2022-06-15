+++
title = "Add ssh-key to Keychain for Session Authentication"
author = ["Guilherme Pedrosa"]
date = 2022-06-15T18:35:00-03:00
draft = false
+++

Since github retired hhtp authentication, I have moved to the only option available: ssh-key authentication. It makes things easier by not having to type user and password multiple times in the same session. In theory. In practice, this was not my experience. This is when i found out about [keychain](https://www.funtoo.org/Funtoo:Keychain). From their docs:

> Keychain helps you to manage SSH and GPG keys in a convenient and secure manner. It acts as a frontend to ssh-agent and ssh-add, but allows you to easily have one long running ssh-agent process per system, rather than the norm of one ssh-agent per login session.
>
> This dramatically reduces the number of times you need to enter your passphrase. With keychain, you only need to enter a passphrase once every time your local machine is rebooted.

And how exactly do you add a ssh-key to the keychain? Here's how:

```bash
guilherme@gtpedrosa:~$eval $(keychain --eval mysshkey)

 * keychain 2.8.5 ~ http://www.funtoo.org
 * Found existing ssh-agent: 1494
 * Adding 1 ssh key(s): /home/guilherme/.ssh/mysshkey
Enter passphrase for /home/guilherme/.ssh/mysshkey:
 * ssh-add: Identities added: /home/guilherme/.ssh/mysshkey
```

No need to insert usernames os passwords until you reboot.
