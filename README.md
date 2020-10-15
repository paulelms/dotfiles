# Linux dotfiles

## Клавиатура

Настраиваю следующие вещи:

- переключение по CapsLock
- нецикличное переключение языка ввода по Caps+1 и Caps+2
- типографика как в macOS по правому Alt (на всякий случай, ещё compose по shift + RAlt)
- нажатие caps как единственной клавиши работает как esc (очень удобно в doom + evil)

/etc/X11/xorg.conf.d/30-keyboard.conf:

    Section "InputClass"
            Identifier "system-keyboard"
            MatchIsKeyboard "on"
            Option "XkbLayout" "us,ru"
            Option "XkbModel" "pc105"
            Option "XkbOptions" "grp:menu_toggle,grp_led:scroll,caps:ctrl_modifier,terminate:ctrl_alt_bksp,lv3:ralt_switch_multikey,misc:typo"
    EndSection

Или можно через setxkbmap:

    setxkbmap -layout us,ru -option 'grp:menu_toggle,grp_led:scroll,caps:ctrl_modifier,terminate:ctrl_alt_bksp,lv3:ralt_switch_multikey,misc:typo'

Настройка esc на капсе:

    xcape -e 'Caps_Lock=Escape'

Переключение языков:

    # bindsym Ctrl+1 exec --no-startup-id ~/src/emxkb/emxkb 0
    # bindsym Ctrl+2 exec --no-startup-id ~/src/emxkb/emxkb 1
    bindsym Ctrl+1 exec --no-startup-id xkb-switch -s us
    bindsym Ctrl+2 exec --no-startup-id xkb-switch -s ru

Ещё можно добавить запоминание раскладки для разных окон:

    xkb-switch --i3

## Тачпад

Я раньше пользовался тачпадом на макбуке, и мне очень сильно нравилось что при перетаскивании чего-либо в macOS можно перекладывать пальцы с места на место (если упираешься в края тачпада) не роняя объект. В Windows это настраивается в драйвере моего тачпада, но работает очень плохо. В Linux это реализовали очень хорошо в libinput. Так же здесь есть отключение тачпада при вводе на клавиатуре, удобный скролл и тап вместо нажатий на физические кнопки.

/etc/X11/xorg.conf.d/30-touchpad.conf:

    Section "InputClass"
        Identifier "touchpad"
        Driver "libinput"
        MatchIsTouchpad "on"
        Option "Tapping" "on"
        Option "ClickMethod" "clickfinger"
        Option "NaturalScrolling" "true"
        Option "ScrollMethod" "twofinger"
        Option "DisableWhileTyping" "true"
        Option "HorizontalScrolling" "true"
        Option "TappingDragLock" "true"
        Option "TappingDrag" "true"
    EndSection

## Режим ракушки

Убираю сон или блокировку при закрытии крышки ноутбука в режиме дока (если подключены внешние клавиатура, мышка и монитор).

/etc/systemd/logind.conf:

    HandlePowerKey=hibernate
    HandleLidSwitch=suspend
    HandleLidSwitchExternalPower=suspend
    HandleLidSwitchDocked=ignore

### Автоматическое переключение на внешний монитор

Настраиваю автоматическое переключение на внешний монитор и обратно.
Srandrd это демон, который мониторит изменения в конфигурации экранов (вместо autorandr можно просто использовать xrandr):

    srandrd 'autorandr --change --default common'

    ➜  ~ tree .config/autorandr 
    .config/autorandr
    ├── home
    │   ├── config
    │   ├── postswitch
    │   └── setup
    ├── outdoor
    │   ├── config
    │   ├── postswitch
    │   └── setup
    ├── postswitch
    └── postswitch.d
        ├── i3-restart
        └── telegram.sh

Есть ещё универсальное (для ноутбука и внешнего монитора) управление яркостью экрана: [backlight.sh](https://github.com/paulelms/shell_helpers/blob/master/backlight.sh).
В Windows я использовал для этого Monitorian, но в какой-то момент что-то сломали (думаю в видео-драйвере) и ddc утилиты перестали работать с моим монитором.
