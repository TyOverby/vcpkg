#Every update requires an update of these hashes and the version within the control file of each of the 32 ports. 
#So it is probably better to have a central location for these hashes and let the ports update via a script
set(QT_MAJOR_MINOR_VER 5.14)
set(QT_PATCH_VER 0)
set(QT_UPDATE_VERSION 0) # Switch to update qt and not build qt. Creates a file cmake/qt_new_hashes.cmake in qt5-base with the new hashes.

set(QT_PORT_LIST base 3d activeqt charts connectivity datavis3d declarative gamepad graphicaleffects imageformats location macextras mqtt multimedia networkauth
                 purchasing quickcontrols quickcontrols2 remoteobjects script scxml sensors serialport speech svg tools virtualkeyboard webchannel websockets
                 webview winextras xmlpatterns)

set(QT_HASH_qt5-base                27e640643aa2a15fece96b1a83f8f6fbfbc8a83e224f6dea4d7e6a94c8069a2b18a55ddc76943b10b40ccc95168a48dcfdf46264fdfc24b3594d1c6ea160aff6)
set(QT_HASH_qt5-3d                  c5ddf964d65b9b889e822c30eec4118e2c2de797ba3bcc448b62eaf190388e9acd4a2ca826f5c3e864d8f81b1af85f89d9833622addf2e79c41114aca0893fbf)
set(QT_HASH_qt5-activeqt            2c507311bcea6b9b0b6845c3bf19b45957786662a13f55e001aa49642bebe0eedbe8d1d787fd81432812326cd4f04067cdd13689a9a2075cbe9366ca17bc0226)
set(QT_HASH_qt5-charts              268c973a65d7639850b4ed5290b0b6c1e97b8258ea29f9b8ffad4140bf66eac42252460e89b6214287cd4bde0f2de0d2effe7ebe1a112f8d84799693b0c8056b)
set(QT_HASH_qt5-connectivity        9e27cd7315f2d5abacb73f4de132ced31c340c075a876729f4567ccd2f47cc11610aabfc347d7b7325d76f530ac3470262fbdd9bee428ddb68b13b4c129e3366)
set(QT_HASH_qt5-datavis3d           23ad4a48af4d28a50e348d3532b050831b1abc0ab17f305d7462f13460fb0cb335ec6a7024236b275a77c5a7da605f9a725f7c7105cd2fa4adedd16f9a34ff48)
set(QT_HASH_qt5-declarative         e9f065ff0fcf6aa2a145062c861fb23b93fb21b6e2ca8820aa7c8fe4ec2cba15e55df7ac803637188110784810476b68548d138987b3524ff002d35cafd50d8d)
set(QT_HASH_qt5-gamepad             ee1c068c48f55d2ecaa2d9d2995ab44a631369b7be0ca3e1880dff59bb13d4017e0a276337afd86a90960297ac9cae7f98e2e01c8f7e180f86e398ad89b9f7de)
set(QT_HASH_qt5-graphicaleffects    3dd002a02fe2ec6f91cd4b9565f766596eac00c562bbca25dcd9081a228f8854ae032d8035d9d4390a280e3d805bbfb7b77969746ec51b72a8bddb4a58009242)
set(QT_HASH_qt5-imageformats        e674c461b5880a2df17f06726c647dc89837c7746dbd0278a6de8f6291e92ef63ae2ccb3a3288951196e03156ae112e4d8d55ae692a8b6a608c7441fb624d28b)
set(QT_HASH_qt5-location            6d9915a7fba561353df6b0e1983a333af1ed85d22761c4022b7bb4ebf56a4ad2f895d1d7f0996cc93254346fc86718c654e1837c2d79358a04cd1e30c70c39ca)
set(QT_HASH_qt5-macextras           d27ab2b44cfcb1a4d02cd6d2403710546c8cc1bae834418975f7588bf647c822519c4701b4feaa5bca98e5ad089eb2dd9f328956339699274126422324e042fc) # needs new hash
set(QT_HASH_qt5-mqtt                8aef8c8e6b7ef6acba864583396b680321c26b1f4910925e182592482d9363127c0767663cfd815262bdb4c32795c7b3e706c8543c7838e6907abca6d76eb9fd) # needs new hash
set(QT_HASH_qt5-multimedia          ab5cf713e207c0538004860debc2da74830fd4b1d13c3c3ee0b3b9ee8f4438512f94952ec4ca7408cd055b69f4d1b0396d79d123365a6c74c14c4fee1f86c622)
set(QT_HASH_qt5-networkauth         ef158b5185bd9afd4bd634c26bf09f25cd4d8c8c879aa475d267f96b74b8ac90cb817c8475cc2cdc0892f79607e3eb08fce62e1a913e62e9ab330239af6bd7ac)
set(QT_HASH_qt5-purchasing          1dca7638b93367b3b392ea0a3e84c4edddcb2ea80de73da391c806f534a6dc57b7c50b51940363db2de8662f48c9d27fa4ce1c32e9d60e0f2470485516b6e2df)
set(QT_HASH_qt5-quickcontrols       5471d6ff66c9b81ef36e6261bc7744f30571a36d1f47bcb574aca43891da4ae19aa9c90a18f24a0223cebd4e633f1313399e675a20ea6643cbfe0ce2212264e0)
set(QT_HASH_qt5-quickcontrols2      ab132e7441a2afe4636d3c3f5bd76cc0b21d5c2a5d2e83b0f5b6468698811fb9113519885bc3cf90d9028d38992eb7be049563d3b43069e59b62135dc7e07123)
set(QT_HASH_qt5-remoteobjects       3920c0db60f6f5ef2507a42fe093476dc129c76d7e5d527331a6ee26e0c87288e124d1daf823dfa2caae3f7e67a3aa415779cb0f920f1985c660974e9e6c0e6c)
set(QT_HASH_qt5-script              91fabfa5775fc411b7b48b74419275bd6ecbec7ce3eda186f875d973b05a5501b2226a2ef0f6cc30d850fe73fc1466c2fc7e54d9f15e939eac6ecffaae65b8ff)
set(QT_HASH_qt5-scxml               b6c214231d3493efffd23b3cd825a2269192a3213a4bfa6870632e6017cc456a33428e00a710f67894d35d8237799c950c52d6fb70c14d1973a0fa9b601ccacb)
set(QT_HASH_qt5-sensors             de9522cc6a2656eaf78376ef5803866c97298ee348c15a45b093e30302594db6dc3e31f619b444aaa970b157a6077bf189585de24dcc8c35c6be5930fb35cdd2)
set(QT_HASH_qt5-serialport          bcf65bedc9d96694cafa7b2984bf8f0aadadc5fba9bcbd2b57c849bdffa9677ae3f90796ef5e002641241af5c44404beb83bbd2083d00614d5376f68b109b9aa)
set(QT_HASH_qt5-speech              516a59f1e819db5bc3ecd2c776767ec518f0898daa2a3833dd95f62df5cd4abcde97312a768faaa47d9bdbca122eaef44c1cbca5151b5dac3b3b65b61a8c7c42)
set(QT_HASH_qt5-svg                 eecc808311c4b149800edbdf9695a8f6438e01757d19938d554e816f44b92c3571c5f7d8b6e5cc95fa2e527e1b068707d8be4fd560c80a3b2d1900ca0b868378)
set(QT_HASH_qt5-tools               1c77d6b6027d301b7afae92834ba2296b903495cd0546d53e9d82cd24289089d02a4a7b0e802061ead4f9f8272f8389fb5f06f3788aac3624f52593324ce78dc)
set(QT_HASH_qt5-virtualkeyboard     a4101b8bc8406e02c1165c20df639f07b822df2106ae21a66af10afcc965c358ac8d9cd691570592332c0cde33276f284c300b20e2d2a6a27160bb47bf0764ee)
set(QT_HASH_qt5-webchannel          fbd201c305989dec92c13e6a300ae72282002ec5d2a415920a34b0c1d345a46d42b44127cd0a5ab288735797cd535bfd9fd1114ea950a612167e15df7eb29525)
set(QT_HASH_qt5-websockets          4951fa4d757ec908fbd759ad48d531ca4d006950ed0318a2d478cc807b0bd3601465407d6a0b53c217946a2b8fa8bd5bb8f0b46435e3a7aea95f2496fe45bcd0)
set(QT_HASH_qt5-webview             c10cf7b921735050dc4478462e404e2d59ca804b3e113aff95b38fd23c010e2e0d2267c6672a36a9cfe6a7d9c9bafa00b6b19d9a29293414824cb8a389642f91)
set(QT_HASH_qt5-winextras           c05533a7284073814f542dab3e87079c031daa9b8519ed8c68a8f0acf1aac8570e2838fea9578447be48ab1afa5acc98f56cdd33ce5c9fbfe45b2d4dd9d0706d)
set(QT_HASH_qt5-xmlpatterns         434342a8cb554a362dafeb46fdea28f8f106c9235062cb7bf045c51b7a259072fb671d60c14a20290c856a741de138f144f0fe0a32adc6a4106ad3fa80b4d803)
set(QT_HASH_qt5-x11extras           1e83c2d350f423053fe07c41a8b889391100df93dd50f700e98116c36b3dbad9637a618765daf97b82b7ffcd0687fc52c9590d9ce48c2a9204f1edc6d2cae248) # needs new hash

if(QT_UPDATE_VERSION)
    message(STATUS "Running Qt in automatic version port update mode!")
    set(_VCPKG_INTERNAL_NO_HASH_CHECK 1)
    if("${PORT}" MATCHES "qt5-base")
        foreach(_current_qt_port ${QT_PORT_LIST})
            set(_current_control "${VCPKG_ROOT_DIR}/ports/qt5-${_current_qt_port}/CONTROL")
            file(READ ${_current_control} _control_contents)
            #message(STATUS "Before: \n${_control_contents}")
            string(REGEX REPLACE "Version:[^0-9]+[0-9]\.[0-9]+\.[0-9]+[^\n]*\n" "Version: ${QT_MAJOR_MINOR_VER}.${QT_PATCH_VER}\n" _control_contents "${_control_contents}")
            #message(STATUS "After: \n${_control_contents}")
            file(WRITE ${_current_control} "${_control_contents}")
        endforeach()
    endif()
endif()