/*
    AER: Memories Of Old
    Version: 0.1.4
    Author: NoTeefy
    Compatible Versions:
        Standalone (PC) || W10 (functional)
        GOG (PC) || W10 (functional)
        Epic Store (PC) || W10 (functional)
    Load remover which takes into account the actual loading flags used by the developers
    
    CREDITS: Some code may be inspired by some referenced scripts and their authors: Avasam, DevilSquirrel, tduva, Darkid
*/
state("AER") {}
/*
    startup{} runs when the script gets loaded
*/
startup {
    refreshRate = 1000/500; // cycle every 0.5 seconds

    // init version and debug flag
    vars.ver = "0.1.4";
    var debugEnabled = false;

    // global variables
    vars.watchers = new MemoryWatcherList();
    vars.cts = new CancellationTokenSource();

    vars.resetGlobals = (Action) (() => {
        vars.watchers = new MemoryWatcherList();
        vars.cts = new CancellationTokenSource();
    });

    /*
        For the brave souls who think about copying this inline action: You'll be damned by the god's of programming...
        If you still insinst on implementing it, make sure to be aware of the things it can cause:
            - your pc might explode
            - it might summon an AI which will then destroy all of humankind
            - you might fall into deep depressions
            - you might want to code in ABAP and Pascal voluntarily
    */
    vars.playCustomBleep = (Action) (() => {
        using(var soundStream = new System.IO.MemoryStream(Convert.FromBase64String("H4sIAAAAAAAEACSXdXTbyPv1xyhbliXZspM4YJcZUmZmpi0zM+N2y7Bl5m6Zt4zbLW6bMjOTHXQc2ZIsMs+r3/c9+ScnR5lzzzN3Ps+93du1bj3tNwB6N+vVatTEGcVIAIBK+Wl5GoCVfVRADUjQsV2P31KVv7fr3LpLux6tf8OV3zsOnTWqVp0qtWpXqZZZDYwYOmNopd/+7z/j0IoPzkiUrlN2Ysmdzq/pK4o1Kh+o0a7hoMYT6q6r2DGtOZaibpJoBJeq4uB5ZF/g58+Hr7Y9SGT9eLTiTda3g9mVcs2eCd/7fM38mVzYN9zM1Cq1QcmSpfnibTNKpkkZV0o/qJpct6B+pdoXK6xIM5ifqhcltLCpqqHKEWvG7c8u9f7rkyUPhzwt/s79PSenKG9cju7XX99n/OK9T+VDhrbJE4pFS/QvJqXNdWxM61niZkVfjS51LtXYVn5N2inzHM2ThCchgkGqevE9fKX8IZ9TXpZ5ir349b7Yz/S8/QVn8nZ56J9FbrJwmdREP9h2LONqscvO7ane5NaOiq7nZZ9X3VmDrFal3KC0crhTmw6fJ06BSSpn4pY4r3Da955vf77IefXy47RfQ/IbFH4rSMvt6fkze3bhUjFZ+5flZ+pIp5xe2TE4yZVcJl1f6lLFD1VrVtlcpjB1KX5BOxfeSowFo1Q/EofkVfQw9/yP59/8fJv7Oc/9d8FLH1O4I/9mTufcFN9joYo6ijtTdOkl0q4ku21J9s6OMcWOlTVWKlvxZqkGqWfx2rpP8F6iAuiimgnbhkcwjtxdX1d+gB/KfpudHfP2opkiVWGl/Dr5ou83YTlYik2yb3PUclRLGkyVp/YnFaTfKFm2HCh3qERXx1l8n64eeJUIw8qqfHgtEuJOFOz9OeZLyy/rftTIHeD76v/q71+0y9vUq6ErCBmwIfrcWia5WvI+2y9Ld4vFttvxy9Wh1MVSvxWrkDIHD+i2g/zES6hR1QV8tLsQ8y3P7vrjwPfyblP+m6I+zGVmnx8r6uXr7G8oyPFyhmbkeVuaPWQdQK4nTlsmJZVIn1SsVfH3GXeTCLy4vhBg8CT8AsYDGBsnOQNd8it7MtzubIO3rf8624fby5TwV6L7BToImvhMfS+8wHqPAta1xEa8EbnZpkqd4XzssmZcS5qHX9F3VJWAa+E/YD/YGV8k92HGFXz2VHPPyR5YcJ2exY7ncpkR/lJ0jn8874mO0q0xb7a+p9pbnxFr8XwiSI10oM6Prl0Ze5MXEMuRB6qGcDTcC+6A4oneoQFsI2+v7NJuY/bl/Ap0KXYOV5o94y9DL/RvCT6NtNNewypYf1HrrHZyA76T6E/dStmX8dqV5JyVMo8cZuigHgLbw/ngK9iXqBjux5Uu/Jhdx73Hk5S/pugVM50bzwb99ekS/hfcpXBVzTfTVct36rl1EHkA/414YnWkuDKyXIuc7R1/WFobv6vXwlqwJ2ABCqPhnkGzb0JOe3dLz4w8v28MM5E7wLYIdKO/0CbuWAhTB9H6lkeUhTpK3sSTiabWKcn70g+5fjqTU2dbq6JzNI9gOqwNGDAd/hvpyYd81txJ7pD7S24HXyLQk/vEbgpMo/fSfdkDciEA6N/kaaolJZA/8QL8P8vDJHv6VFdV19vUWVSqqZRWC+zQCATwEE6PdhDYolu5R9yX3c1yjxeuDNThdNzPwB56PH2N2SW9gBojRv5JTaWaW4zELby9JS1peVod10TXyrSJNiv2XvsbIGA2DCg8Kx5rIPrpqXlB9xz3PzlxLxbAuMpcZeYl3ZZOZ46JxxIqwwiiC/UXtc7SgDiEfyLn2otSBeduV830AXbMvF53STnrNvwOuoIHsXJSob9WfktPV3fVnG7edf53bHduOmPyV6W3Ba4Ky+Oi/hyOUdeoH5YpxFZ8Avnd1iF1n/OW60V6xyQE76lPVTngbngfrAD945ScG9AXHPPUcZ/PPlkA6R3sSC6LaaU4LCPwgh8X8+gC5n+tb6jS1vPEOtxMNrCdcjR2vnINychMRohSyBpVTTgTngHnQH6cl3OZzwVp2RXc9bO1BePpLuwUzsSu8pejT/rDwfbRF1qnub/1BzXJyhNr8BvEQQp1vMr46PqeYUvRkXHErO4E+8D14AUYm3gWymX/9f6lnPXWMyD/c5HIzOI6sa/91el2/nLB2pHzmtZYwOKmLljrk7vxyQRBjUjpl/HS1clJp2gtXw071b/DBnAC8AB3Ymc4h9tfWCanqXui505e7aLdzDTuT7ZYoBkdo4dxpcKb1MNM0y3vKc66hDyHZxILrbeTv6dfdF1xXnWorVnGTM1JWBa2BgHQGg6KuIOrfVk5g902T+m8rb4azBDuDjspMJi+Rp9kHaGpqqmon7xBVaZekG9wCYcWa3Lv9DUuo2tBatx6Dn2poWESzAAiOABLRN/zy4tG5m50v3Svyg0WZgVacUH2WmAlvYhWsxa5C/jd2JPcTQ2knBYRf4EvtoxPepzW29XFVTctTB0yLdRmAhxGFYeJ8GX0tTCdduU9c292yzntC9sFSnJpnJH5h+5FK9SVKsMFhvPEJOpPapylNHEGN1nu22umWVyrXdlpjG0bVke3TDnrFcwBtcHvsVviFP/3PIdnhHtczlHvIz/DNue6MkG6Jv05UEI0J6YhGqISdYa6aulD7MD3kyXsu1KznJdcy9Pd9i1mUVcErPAsfAkmg6T4cWlS4FD+LE8zN50dKmjuv8T25/YxFRXu9AjUF7yx0fqWeJ71AaWzblEcVo9cZgs7xjufudIyHiVtwu/q+6hKwpXwKtgL/o6vkicz0wtyPJXdk7J7FFygp7ITuHxmvL8E/cvfh38T7aRbZF5h/UR1tb5WePiLKKB6OTTOz66DGeeTVxO7kFeqxnAU3K3wsGpidGg828PbO7uiO+E5k59Gl2Cnc5XZi4pbf/cvDf4Tqak9jRWzeqhN1hRyK76J6EZdSNmc8d6V6lydspacYeipHgrbwT/AN3A80TA8gatRmJtdw73bo89fUnRPcesENuavSxfz3+YOhVM0T01nLd+o9woPj+AdiHtWJCU146ZrtbOPY4Olh9Gr3gCrwx7ADyhoiIwJFvPNzunobuQZm+fxDWfGcsfYdoGu9AcasptDYZUbrWx5ovDwjMJDG1HHOix5W/oBV7azTOoKawt0kealwsNMhWGz4JPIMJ4sSsmd5WbcL3Mb+cKBHtxPdktgJr2L7syukz8C2niA/JtqS4VJN56L/2v5JwlPn+Sq4cpOXUZlmippzcACDYAHL+GiaF9BRz/KPeM+7W6Yu6Xwz0BVDuM8gcP0CPocs0q6AkVDnFhKzaZaWkjiX7yFhUyam1bbNcG1O+13Wznsp3agwrBf0A+soGqsowjphXmiwsOTOaJXHTBw1blM5j3dik5mNok7El6kH9GO2kdtU3h4FH9OTrV7Un3Og64m6RPsxc27dNeVSV2DP0B38DrWSJL9bfJbe7q7S+R08C7wv2c7cYsUHlam1wcOCzPiHv0hXEfdpDyWmcQmfAT5wtY8dZvzrutzev+kNHywvqwqBf4F74D1YHC8rCwErAXnPTXcJ7P3FUj0BnY095Dp7C9Nk4Esvnvste67+bL1HVXZellhmJGsZDvqqO587xqR0SI5haiBbFd4OF3h4VnAxdUhkfEXOLMruTOzw/lD6DbsNA5nNyhnHfN7g7WjN7Qmc1/rR2quwsNN+EViBwVTnigO82YUT3GQqCFF3QX2gmsVHk5PfAiF2Qfeo4pbn3h+y39cxCsbtzv7SWF+G78jWDyyV1MDy1N4eNHanNyBTyD0VM+U3zKeuHo5IylJFtpwUP0HrAfHKTzMT5wI89yVwso5Ld3DPf/kVSjazoznNio87EBzdD/OHF6k7mIaZ3lH8dbVCg8rErOt55Pfpp9z3XA+ciRZ3xnrac7AMrCJ4rB2cEqEDe7zvcgZ4rZ4UvJW+iopPMxipweG0FfoPSwS6qcahrrJW1QV6j35GpdxwaJP7pi+0kW41qQSVBb6VcNDEjpBEJyAFaM0v75olsLDZ+5FuTmFNwNNOYn9L7CW/oMOMUCuB8Ya25E7qBFUMUsEf47PtAxNupHW3dXT1TINs10yrdLWBSYYhoUgAr9F3cIKumLeG/d6N5PToLBFIJUrxuHMDborPZBRS+lwlOFvYgS1nppqKUlcwBPkTXvpNMK1zsWlJWynsWa6jcpZb+Ev0Bgsjr0RF/mL8lyeoe4hOdu9d/xFbGuuj8LDWvTzACFG44MQCS9HnaNuWAYS2/CtZJp9pcLDc65t6X77MbNGzyqp4m+Fh9NAifg/0tLAhfyFCg9/ZjMFNf3n2UHcAaa6vyTdMVBe+BTrqq+Hf7U+p/TWv4iVeE1yji3gGOF86iqX8TnpMP5KP1hVDi5T8uFBcCH+l7yIWVIQ8JR3j8tuWXCCHstO5vzMVOWs9/4O/I1oPd0083zrT6qL9RuxCv9OfKM6OOIZn1ynM24kHySOIt9UTeAIuB08AHUSs0IL2SHe0crGDXn251vpVHYWl8n+6y9LT/PPCh6MlNDuwlKtbmqb1UluxtcTbakjKWuUfFjauStlL7nMMEQ9UsmHU0EOOJ3oEJ7PtSwsUvLhZk88b3rRXWYqN4OF/ga0w3+WWx/Wam6Yjli+UF+to8hjeGvihjWSbM247troHOvYbxllFNRbYFXYXeGhC1KRecHKvmU5Xd11PYPz3vsGMuO4v9kuSj58SzPs4lCO6hVayvKQslPnyCwcJWpauydvTN/p8jurpO6zdkU3al4pPKykuHUhfBf5nc8oKpc7213kvp9b3RdQePiD3avwcDvdlJ0n3wbfjVvIE1RHKkp68W/4ecvZpHjaFFd1F5e6g2pqaqAllc2mUXj4Dq6NThCS6Xe5/7iPuavnri78Q+EhzhUoPBxFH2RmSwfgT4NELKDmUh0sFuIaXtuCJE1Oy3TNcB1OW2uri/m1wxUe/oBFIA3UiQ0XTf5NeWH3TPeBnFxv1K/hanG1mM90cxpjFosLE1+RTkQr6jC13dKK2IM/Iwfav6TmOQ+5OqQvtFczn9TdBaTCw8+gP/gS6yCZA93yu3s6uR05jb3T/a/ZLtwyBvdn0ksCO4QB8Vf6TTig7lAFlrnEBnwweddWJ3WDM8uVkz45qSI+Q19O5YLb4F2wAUyKV5cxpnjBVU9N997sbQUF9Hp2FPeS6ao4zBQ4zzeL3dC9Np9RGkim9briMB1ZwrbLUdH5wTUpo0dyRaIpcliVCWfAE+AyiMeJkJkNFVTMLueukO3P7003URxGsNuVrLnP/zFYOnpIqza3tWZTM6yAXIefJ1ZTXModJR/SGdVTKpCphhLqHrA7XA3egjkJXwjhvntPZme6b3va5t8qopnZXDc211+BbulHgnhklaYE5rZ8pW5ZW5B78dFE2NoxpX3GQ9dQJ+KoaIkYTqsXKw1krOJWJnEljATvFtbPae4e4jmR5ypapzSQLWyZQFuapdtzkdAkdX3TaMtLKmrdQF7EyxMTrceSH6Wfd912fnaUtuYbW2ouwZKwKeBAN7gwouLP+b7kjHCbPHjeXF8ZZgD3iJ0TGEFfoDexvNxG1Rn9SF6nqlM/FB4KuM8SS2qRvtxlc+1MLUm9Ros0rJIPU5R8eAbWi0b4Q0WLc3e677pn534svBxozEXZrMAmejbtZ/xSGdDL2JjcSg2nKlrC+DN8oqVH0uW09q4Brk5pxWx3TTu1jZReKkEfSMDCKCfspuvkfXKvdmfnVCusH0jmSnMEc5fuTHdjOBGBPQx7iKHURmqGpSLxNx4lT9uLpRlcG1zxNIv9JtZVt00568X/eLgp9kvc5pfzSnsGu3vlrPFe8heyLbhBjEzXpu8EVKI73gnx4qUUHt63DCZ24mtJ3L4w9aaSD/enQ/tVs10vgRR4EL4BM0GF+DNpcyAr/09PQ/en7OyCCv6z7ADutMLD0nTLQJLwKFZfXxH/ZH1K4db9xAq8Kjnelufo43zjqpThS7qM/9KPUXi4UOHhEXAjfkreymwpEJR8OCi7bsFeeriycQPMXL+TfuOvzx+LltUNM/9u/U71tH4n1uNviI9UY0cw46vrYsar5HPEVSRb1Uzh4WbwFDRIrAptZqd6pyg8ZDzb8rW0nZ3NVWdvK7l1on9kcH0E067BKKUv/2UtqeTD5URjalfKEoWHlZzHUy6Qmw3j1GNhczhb6cvXE73DG7lehXJ2bfdaD5s3rui6wsM5rCbQkLb793Nzw4z6pGmf5QPlsY4lT+LNiHNWNtmg8HCnc6bjomWWMa7epfCwi9JxS8KSkTXBFr7VOb3dVTy98h77fmPGcGfY3wK96Gd0ATsx9EL1H5pquUtlUJfI+7iJKGvtkLxY4SHvrJ96yToQPaB5AzNgecVhy2F2ZCVfrahG7h9ur/tqbhlfYaATl8fuC8yn19P12GHyefDAuJY8RHWngMWLf8ePWg4lyWljXA1didRjVC9TC61DyYcqhYdf4F/R+UJZ+lfuVYWHpXMXFk4LVOSsHBM4qvBwMzNWWg1fGHzEXGo+1UPh4XW8iiViH5lW1vW763zaHlsHLKIdrfDwOywAxUCL2FSxmP+vPJVnsnt3ziev4FdxNblGzBe6Ba1ipohjEo+QRkRz6ii1z9JW4eF/ZB/701S386irR/pWezPzNd1DRdc/8BMYDHJjAyVnYGh+b097tzUn0zvJ/4jtyS1nkhRWzA8sFtrFr+mX4VHrHarIslhpDQPIi7aqqcudj1z+9AVJTfCF+pqqdLgV/gc2gd/jreQUpnbBNU8t97bsPwvc9HJ2nMLDfv4M2hD4i8+MHdP9Zz6p9OX6Cg/X4nEi2bbOUUrh4e8Zw5MbE12Rk0o+nAyPgmtAlSgVSmNRb43ssu6S2Z789nRDdiqXwu5WHLbV/yyIRbdoA1hLZeP+YdUoPDxFLKHyU65mfHBJGc1SGpHlDRXUvWA3uAx8AIsToVA65/Neya7uvuJpnH+xKE/hYR82R+nLDfwxLhKerrFj7yw/qdvW9uQefAjBWRunNMl4pvAwzVHXYjJeUy+EdeAIkAukxL1wWvBNYZucFu6+nr15ZNEqZePuYKsE2tGFdGMuL9RbXcHUV+EhtG4hL+OliWHWncl30k+6njqzHY2snLGb5l9YDDZWeNgPro1Y+bu+3JzRboMnkTvTl8b0416xvwcm0CfoFewPuYaqMfqcvErVotzkOzyI/7SwSXXSF7nSXEdTa1E5qKSRoR3alO19GbaKmoQrRWty97pvuifkPik8FWjAJdjHga30TPon81Myg1bGmuR6agJV3pLAn+JDLJ2TjqR1cA10DUyrbPtgOqJtqXRcVunLEMrRhHCObp73w73C/TmnfGHlgEPhoYO5T3eiWzPZIptoYVhHDKI2UfMsVRQesuRBe1IadO506dNL259jQ3S7FLc+hm7QFOyN+cW//Zr8Kp5+7s45C70n/flsS24UE1H68r8BVngZr4N8xzOoy9RjyzClLy8j1fYZqZed/7hOphNJT8zF9UCVBA/DZ+B3UDv+RToSeJO/2tPE/Tz7U0Ex/wklH55j6ihbsl4AEc7Hyuqd+GslH1LWg8RqvAw5zPbZ0d352lU3I570CGf0U/7Hw4vgOHgQvy4fZY4UhBUe9syuUrCJHqg4TGDm+YvTj/2V+A3RZF0X8wyFh/2sucpZL4jHVHWHX8mHtzO+Jj8k7iF+VUs4CG4DD0H7xLbQMXah93eFhwWeVfnhIoKdyTVg7ymvaIS/b/D3SFgzF8OUs45aS5M78YVETWpNytyM5646zkspT8l9htnqCbAZnA5+gbuJUeHj3NBCfU4d9zKPN29A0WVmGvcHiwaa0Gb/Fm5U+LP6L9NmhYd51snkabwxccSalxxPv+ba51zmeGj502jU7IEVYFdAg0owM3Iw2NX3V04PdyVP27zbvi7McO4q2yvQn35Mf2AHhq6oLqC45b7CwxvkAxwh0qyNkn9P3+6SnJ1S71hnoMc0X2GKwkMerIVsZDffrKhx7iK32306N83nVnhYyB4NLKTX0BXZHvJOcM04jzxM9aCMFhr/iv9l2Z7kSxvpauoypV2nRpp6aNMV7gClzfyCh6NbhJp0MPdf90F3Wu7UwnGBMpydYwNn6P70eqarNA/+Y/hFzKQWUX0sScRlvKyFtff6Hw9vpl2w9cEMuinKxv0CvaAE6BFbLFb3n8rTeSa61+a88Bb5Y2x9rjGTQzego4F+Yp/EBaQG0ZA6Th22tCP24VfITvbbqV+dx1zD0vfZ+5izdO8U519VNu5wwMQmSpmByfmDPW3dxpyS3qH++2xvbg2TrtzktMBMITN+Sj8Tl6wPKNayjNiIdyVP24qlLnY+dknpG5O64Rv09ZV8uAneBpvBsnh3uRrTuOCJp5p7TfbCgnf0UnY8957p7y9Bh/2beVtsm+6C+aD1A9XQmqX0ZZHAbQscToWHizNmJHcjBiPnVHXheHgEXAdYonqoMpvmraf05eTsz/mNlA00lXOxB5SztvqvBKORBdqfWGOFh4usOnITfoD4g/qcckHJh7GMXikdyCaGTHV/2AkuVXi4KmEMV+Ii3jvZVdyXPJn5x4vczAxuEOv116Rr+X2cNzxQg2DPLT+o+9ZO5H58AJFrrZVSK+ORa7KzlKO7JdWYpf5TyYdDQSEIJz6EKwSzC7vltHZ392zKMxTNYyYpPKyt8LCArsx9DjVUu0wdLK8oNbWb/AcvTvS1rk3+N/2E66VTcLSzGtB+mpuwOGyobO+RcGukAv/CJyg8VHmk3JG+JKYX94ZdqPDwKD2PfSoXV5VHH5IXqYZUHvkVL8I/WnKTKqcvdGW4Lqe2ogRUpU1ACpJABldgr2iq8KRoZ+5B9zX3oNy7hYcUHgLuZWAnPYX+wDyQVKCKsRK5ippMZVr0xB18qKVO0oG0Fq6hrolpjWxe0wVtO4DCgNJAEKCOWcQ7dNe8XPcS98uc1MKSARtXlnMxDxUe1mPeiF8TlQ3LiV7UDoWHtYjDuI/cbtelhZ1bXWh6NfsPbKzuEDDDh0o+bAEOxV6JrfzT8765v7npXLfvHjOX8zIl/ZOVftopfEA7HO9BSdYosUlJrNFkm7Ocq4RjGj5eOxfehN/B1nhlYbG3gqdUdvvCKFOS++G/Ra/iq6jq4suoBpaNeCnr1tQurieOp5ispLWH4EX8XpDOu+Z+n9cuMI4bEHhKlxBy1NeJMVQF8jm+1uZL3+W8a59qKAmuw2MgN1IzYMtZ5/nlbch62Ab+CoG/Q27EaD1sVRNFxMTk5c7d6Q0tN7WdYB9wDRaX3YWjPLNy3EW9uSfMWfo8ez1eB6tADbTMxN9bWqeirlmOfZhf1RQ+AY/jn4Pp+QZPWv7CwBpuSSBMdxN86gNELSpOnMGH2s6kt3YutncwFAM34CFQEOkW6JHj9hQvHMequDH+gYHHoZ9ItmWa9Rd+j2iR3NjZJl1vOazo6A/Owuqy2nfRk5XjpP/gOOYT7WWfxctjUWtVSzf8nIVMveas6piC/VS1gvcVHQXBbkraGZ5/IXCBOxGo7J8jyOqFBEK9UV5gA9vY9EhGI3t5Q8b/dORHpgU25GRmDy/cypbktvrXBpjQZ+SWpYX1Cn6MIJNDGZG0p+Q6RccARUcNuYpP8thye9JHOZI1+pM4dzwde2bVWCri6yyfHBOduSktsdeq9vAOuB8PBVfm7/Ncyv8e+MS9CAzwHxdi6jHEO+sJYhRus5VJP5sh2VBDMrgN9yk61gZe5CzOPliYxTbn/vPfCRDhj8hWi8W6Hl9CZCedyTiXtp78Q9sODgbHYSO5t69R9tDc9fQzrqZyi025WFyHHbK+JhF8vGWPo7RzR0oKdk/VUUlt9+JG/mY+45Hz7YzEiYFN/pcCqmlNHLP+TrTDCyhf2oCMy7ZCxAIewJ2AjhwLWHOfZvsKC5Vk5/VzgRrhl8hki8cyHB9JnE0amzEwrQ85RNtNmccx2FJe6luefSH3Ec1zvdhx/smcLcGZZlv3k/nmFpZxjjcZPVJyTbeVedwDN+MunslvnN24oA2TEsxgsvxhwaopT8y0diLK4repk2lYxnTbQ8QMHsIdoDDyLNA+t3hOOV8Kt4qzBMowncMvkDaW05bmyj5cnOTKsKalkZ21neFAcBS2l8/6nmfHcrV+a3Ahu81/hCubyDG1sM4kb5lLWio5VmZoU26Yzqu6KvO4Fa/Mly34M3ttwWymcbA5I/iLiRkahGhvdRIGfAs1Lu2/9Eq2vxEEPFWaEBPJDWzMHZ8z3teMO8U1DfRmpoYfIi7LQosddxJdkr6k30vNI+oqOoaCvbCP/MFnz+mYV8/fJLiHfep/xTVJvDKlWluSe81RMpRSP+NW8nrTUVU3Rce1eAu+f8HH7LcFJ5lBwfFM6UBHsaQmgFPWCP7TPJEqmzYl3U8tR3TgGVwPuIiKeZV7LeeMbzz3mhsbWMlsDd9BQmQnC2OO4cWS1qfPST1LFNP2UOaxBw6S1UX9c3bmzfQPC95jJT8Idk/cMvksKeQs82fyRgqXPjV5uGmbqhe8Dq7Hu/PbCorlpHm/MYuDm5legeliZc0zPM/yFL9jbkb5Ul3pp6hRCIQv4VrAR4oxZB6Sy/p2cAy3I3CduRD+D3lNplmemD/jrL1NevnUmQSu7arMYzucIFcoOpGTnXfRvzzoZUsHqgRHJ06ZbloKiF7mc+TKlAPpFZNrmtaq+sCb4N/4GP5JwZScEV4zezh4jVkZ2CPW0FzEz1sO43vMydTfqa/TJlDNERV4BVcpOpoynfP65GYW3eGswayAj3kXvoycIr3kEfNV/JZdlf7V0ZgIabrDYWAznC13K+JyMvO9/vNBA6dko+Dvid2mNZabRFXzGrJLSo/0X0km02LVQHhVuZffeZX3Rs4pbxP2YTCHuRp4LNbTbMEXW+bgc82MdWTqkrTyVCkkDt/CFUCKDGI25x3JnVlUwNUL+gIZLBs+jywib5JzzNvx1fbraWscRiJH00t5t5vgAnlhUd3cP/JLBl4FM7mlgTXBdYkVpoGW9YTRPI60pBjTdyT9Qmf9T8fl+Hq+jhfN5b1T2IIgyhYEgmITzXS8m6UDPsB811o2NTONtqqQhKJjKYhG5jNv8uTcC0X2YL+gnenGmiOnkN7kGrK7eQbe1z49rYnjFf5WmcdwsA7+KZ8uWpj7OH9QgA/25s4GbgX3J2aYMi2DiTysJfkp+VZap6TL6HjVEHgFXIgf4id6e+U2LNzP4nwVNoNJktppuuPFLCXwuuZdVo8jP/WYtUAvKFltAQDRXYw9v0UeX9Q8OCvYmpnHVo8cQGqSvckq5i54eXu5NDblL/ymMo8RYCXcIn8qepxLFWwPpPFzuZyAN/hvYoBJY6lGZGEucl/y5DRd0mp0sGoUvAQuxa/yx7xHcpcWvmar8T3Z7kx9qbumGs6QsjnJPMF62LE1dbT1sT4IP/9Px22mZ/6GvDr0uODe4CTmEtshsh8xkuVIxFwJD9k8qUdSRuAnNT3gGLAEHpRhkS1vcMHrQGN+P2dh7PzzRBvTZ1JF7MVixPDkUmm37IPQPqrRSq84F3/Bf/cGlf6l4Xrwi9iFzBipi8aBXyNfmzmlrw52tE8tYT2rL4QeOAvooj+YbfnuvOn0tuB/wT1MNjsxsgXJJmTCg6H4A9uu1J4pVfAtmt7KvSyFJ+Qq9IC8swVaZix/m2vBtOR/JGqaTpBv8PnYW6Ji8ofUafbaaAfVWHgBnInn8kRhizzMV4ebyp9mzzHrpf4awbyePGx+gzms6Y6QI9+yRu+H3+AcRYeKfZdfPf8ifTuYE3zIUNyayFrkKvGIuIZ5zZtt3VINKSHzEkXHKLAAXpH70sfy5IImzGq+gJvMTOf9CZdJSf74AOwUwSf9mVrVrkfb/G8eJ+Nhvl3hhrxevhHcdv4tm8NckoZo3pkHkbPNF7Aiy8+UY44TlvF6H/yltB9z1Mk6Cubl87Q3qON5pgX3d2QJspHYSWzAHpoH2/Spd5Lvmqcq/hgHZsCH8hI6mNfcO5s5z5uC+5n9fCKBmTqQs/A62J/E1aS6qV7bD2MT1XhlHqfiZmFp4fe8vb6t3HVeZm3sd2mk5pK5MtnRvA67Y/krpY9jrKWzvgBmw8mAjDZlBxQ8y6/lJ/kKvIudzT2M/IGMJMYQ47GD5kzbTceU5PXmAZq+cCyYBV/Jl+g6+Vu8p5jPfMXgW+YFb4ESmka2w+3YQGUbeR2HbJeM1VVT4CnFH8WEW4Xl83N897nvfHGuOYvIIzS7zCGipHk8ttXSM4VwlLLU0v+ChcrZydEh7L4CR8EMf12+I9+WPc5lR2YgDYg6RCtsnhlS0xylk/ua22oGwdHKPL7JP+kl+V+9Pkbk+wZjTIwvCX+ifiIND5jqE82T9jv62dYay6umwtPg73hdQSqckV+hSOZifDtuNltGnqSZZn5GhLG22DhLUsrNlCKS0nugV3kD6dHFbHbB6IJL/lH8RH42+4kD0bEIRSCEExtofkKVd3xNKmGurxmg6JgGc2Wr/3F++cJ01inMCVZlywh14CP0HkGbX5hIwpjU2ZFkG2osrpoBjys+7Shk+u7lTy4qEywmzOCOs53lqZqu5r+I51gFrL7lQ/LElFNkWPd/8xgFMqJH2dLeCwWifw2/iT/MGoJp0aGID/+AR0x1zLuoXynrklis7P/mMRkG5QZ+e8HUwt/YVsLe4GC2h9AKXkI3EXfMx0x+/JkdcTymmhitqrnwqOLTUcJIH1Vwpei3YHNhD/eFnS7P0lQzjyWOYGrMYtmQXCxlIvlN9w364EhQPPqIHeFVe6sF/uUv8m/YusHa0T7ILfxv/LUpxTyU+iulSdItzK7oGAMmwIQ80d+/4G7hanascC+4kV0o9IJ70BHERvMK0318s/2flOWUzYip5itN73R8vnDAN7ggUrQ0OFq4x6Hcbvl3jdncgJiN5ZuyyS7Jr5KrkTd1XxUdg0G5qI897u3mnRTI4d/ygBsZ7Bltj+zAZ+EnTaKSxLunBO2rMa1msKJjNMRDu/wnClBfFrtOKApeZy8Iw+EKtAYx0jzMtB/vaR+d0oQqNOj/p+NkfKvwzXe6oAV9IbhKoLn6XJY8R8NgRqIrdsd0nTQkL03miEO6j5BRMniVqJkr9B7wngmggsRX5nYEp0WbIhPx1vgK00ssbEVSjtr7Yox6hHIvI2Fq6KmfLejpC7HnBQvvY78LM+AUVEvUNjc2zcYddmeKaH1sEMCfcC84Gz8pJBVFC5bT+cHjQnJwIpcjL9Y8xz7hZbG9pnXkg6Q6yReIlbq3kFM6SfVoJlelkPYygSqCU+jNPQ6ujtZFmuMOfIDpLPbIei15iN2JZauHKTqGw/Ihyd/Iu9dXjXsv1OTTOERcDnuiX3Cj2WHqgX+3vUy+ZN1r4MFyuEfx6R2he1Er7ysa518KTYN7OCw0T3MKO4onTHNNQ0nllSdNJyYqOkTYHTSKduOmFzYsLMMMFBoLS7lw8ES0HJKO55nrm1Zjm6wzks12zvRKmcdYMATWCpUN/On1+sZwYaEf34nLFLfCpuhx/BcmoBXwg7YlyROtMwx+ZRMdAMfjv4Q/i3Z6cX8znhHGBZ9ytUILNCuwOfgr0wBTVbJJ0u6kOkRX3TvIw99A0+gs7mrhysLRzHJhqHCOq8jfjpZE/OZ/zTbTCGygtUJyli3LdE09XvH0ENgy1Cvw1lujaC+XIS7k53P9xKOwNPoHfg57j2rwIbb6ycWtPQw5YJUyjxNxSbhf5PH284/lk8X1Qcj1Ci3SjMFa4mdMNUx6UrJ3S5LwhronMAY7gNbRPZxU+LXwCHNaWCl85fry36MW5JF5qZlDG2OVrL+SfretNZ1Rj1V8OgB2D60MpBXOL3rHNRWP86e5leJFaEY74Eux8+g3c3lbflKupazhO1gDdynvBRdjRdULd/oP8DXFm8FqwVmh5ZqmWDK+wGQ3fST+tcfsWXiK7hWUFB2doze5Zr7ivhzmg3BCMAVX8qGoDtlr7mF+jjqwkGVLUjVbX9M+RcdYoOy60MXA2MJHRcbgSPEZ/4O7KGZB3piB98LWoRfNNLUzaZ9FbXgPNsBtij/KiPXohYVu/wu+t5gbHBg8EFqsKYW5zf1MHHqamGq/YF+CA91zKMOOoGu0gFvkm+ZzsXHhqVA3+A9viYX1U8zlzAfRsOmupX1SLlXWtF49UWFeXzg15A2cLbTTDYIbxACPB7+Kb+EXI2Mui01CV5gvUe2T+lh+Ik/AFqWRnI83FWfSTwtLBsL8fBHjNwf/U+YRM/1jrmB6i/5OVLUPsbfFc7TPlXtpAQZGtcFnvuu+IWwpMSCMDObzFWKMvqU5hM1FP5lWW1RJuygJXaierOjoBReGHEy0cBA9NXhBTBLqB83SF/jAeNscM7VBR5gnU5ok3HITyQJb4SZlz/UVL9DJvgmBksJhMZN/FHSHVmg+mZaZdaYzaEeiyGa1m/EX2kcQwmZgZLRSECtCi/5iO4mUuCGYLDSPZetTzY+wPuh5U0/LVXtH6iE6RdExBvwG14U6MM18p+ijwU9iXWFSsIbkhSeNG8yvTSXRhuZq1CX7c3IrcltpGOvBxfg00U+P8p0J/CbcEYfzbBALL9TcNHUx/0RXoU7ihO2B7bX5ovaBoqMxGBvtGexS1KfoAztHrCXeDrYU+sc+6BlsF1YdXW0qYRln11Nb0aHqKQo/usO9oXnMBl+Q/haUxWHCnuBgSYLrjMPNB00AtZol62j7CnIS8g/YDdcpOXmDWNZ/yccFFglecQlfkS8VXqXZaCpjPotOQP34MNsc21bzX4oOABqBSdF5wa1Fx4ps3F9iP9EfnCbMimXpH2OjMRwdZfKRpexXrWPQTuqZSi7sBs+GzjJffY2UrJImrRSeB1dJKjDDWNM80/TLWIj9a02ytyHbIheU5rcWXImfEEf6oa+e8hJR6QLfk++qzGOaicVWo63Q/3CXraKtv3mJNguqQH0wJ3ow+KWILerO3RPni+n8PmFz7IL+AFYXyze2NF0iv9omW+ugzRQdo0BHeCf0kylVtNzfgm8hnRUSwUuSGfQ16s2tTTeNd7D51ic2LVkKOQn2wTWKjgfiAX/XojnMd6GC9I1fyU8IL9N0MN3FhqIl0C34R8pDpZvHau9BNagHFkQfB9PppvRqLiAeENvyr4XjsRP6KZgZu2t0meaT622lrHq0pno6HA/awPchjJ1W9NI/hx8nvRYy+a9SMmhmfIulmnYbt2NNrHNtdwkVchgcUJriP/Ec8bP/QNE1BhU7STrhH35zeL6mvGk91hCNG4crjX89lY91VnSoQA2wOuoLjqLX0E84m/RQnMGrxRuxXfpW2GfTfqOEtieb2n5aPhhLq+cq/aUjdIdasteKHIHT/GopJvTljXIxUMF4AOPQGcapGLRUsi0gvuv3KTpWKj07LDoD+UUatoY4Waou5PJXwvM0atMwjEB/GGvhHalW1N9YHe1dqAdVwZaojT9Bf6VVwYZSoXiQzxQ/xFbq07CTptnGt6iVDFGbLX8breoFio62UAzNZPX0kICbPyuVEFfzteTygDROwx6g3Y2tsduWPKoWcUu/FRyFy8CteLLUJ1CPbsqOFjdJ/QWH8C78h+YXWgUrNF4z6nCEClmnYi7tHagB1cCOaBPeR5f3NwiOlozSW36ASMfm6QOm+aZuxovoR+Ic1doy14io5yk9ux3UhI+zXemTAUp4J7UWb/J95bqAM7TEdqKVjU5siWUzJeE79RvA30pDy4pXlXYEltJ/shvFf6WlQjtBDM/RXEMBdse4w/hJabgnrfUwvaIDAZXAkehwvqZ/sn9e8E+pphTl14mq+AR9lqmzqaJxDXqYGEZBsr0xpiSb4aA1tIe/sntpLtBGkKTJIs0vlZuCjwY7Nh7FjLyphaU1dQmfqV+t6FgE/ot3l94E3tMP2JviF8XVfwi2yGzNZvStaatxtvGoeb51kDVqCmpuQRMoA85E1/Jz/Xf9l4MXpZ5SBeG66Ij31e80uUyIcRQ6gUihrpLpxoBqgfJemsIKYSU10fWZeYJD3i6mCaflTuC6ocDUFC00PDVpLWHrFLynfik49b95TJAoxulHOa8Yk74IZ4RakZmaCehB0xRjF+Mscx0rYX1g+qq5oegoDa5EL/N3/WiAC36Sfpf6CoVi1Xhb/WSTH803NEJrEi+sE0nG4FYtUe6lNawXbsFV9y9mLggN5Ntie+GT3APsN1wxUehDwz7TI/KUNROvol8AzsA/wKP4GqkTM8nfXnkBxWQofBd6RyZoOqPjTB2MlYztzAHLPct6U5YyDzMoBrKiX3gk0DdQhtfJO6Q1glVqE6+vb2y6h942pKJxfKm1NHnX8Fa1XMmyLWGH8Bxukf8xkyMMlXPFPwQo9wfLDctNhcajhummVWR/K2vG9H+Ac3CeouOEtJa55V/DtZEayNVFRPwjMl5TGm1kchoxo8182jLL8pvpjOYaJIETPI7qhI6BY4GRfBn5jnRFaCX1i5fVJ5k2obsNovEBXs/6hdhmuK9aAYeC5nBg+Az3xG9lk8Wlskk6LZQOjQUjDH0Uii0wdDG1IknrabNfNwVchTPAy3iW9ILRB15zk6RRch+xgbgzMkoDUNwkGbyGbGyUpYLFZdqszANXdLyPVha2BtjAfr6L7JbyhCnSlHiKPg8dhU4zvDOuxjnLBmK84bJqjTKPFnBaOJuzBfqx7cTjck3pq9AlNBm0N5Q1bTb2M5Q26ciHllHml7px4LrSWN/GPZKR7RMgg7ulFfJScYJ4NTJc89n4E31heGi4gqVbPGQOukBzG2KKjh/RXsKPQD3mJz9VNsu4eEBaFtfpb6OZ6G+GI8b++F5LR6Ke4YxqleKPhnB12BocFjjEzhOfyX0lTJwdmgvKG2LoUGNjg4g+IaZZKppP6caAa3AKeB9Xy23Zg4GewXvSWfm0+Jf4KTJAc9F4Dj1iOGJYgn0mN5Gn0XHKPDCQDrKjfwrpzBrGIuyRK8lNxOfS7jiv24hq0MqGJUrS+s2iITDDftV6OAg0gbvD7YJnA4XsGTEgL5Pqi/tDiwBmeI7WNqYanqKriXIWL7ZKNwr8C6eCD/EMeTUbCGwNBqXn8jfxqShHemvWGeeh8w0LDd2wzWRzcjbaXXMdWkAS4KJnhNHMW6az8J/cXZ4khqSzcY9uJPrZqDf0N+abjZabeDayRdExQNFxNrwwGA5kcm6RCh2XJooPQqsAh+xELUYOOYK2Ib6Qf2NjdEPADTgJfIq3kO+xzZg3QZfMyFopKtqiPTQjjF3QPoY+hlJYWzJCNEEbam4q/rCDWPSzcJZxsX8KXnmG/JdYWs6Kv9TVQU8a3Ug940nzHXIafhVZptoCe4NW8Hb4n2ArZjZnleqEXkl7RH9oI3iHjEezDW+Q2Uqf2kiOxtrp+oI7SmrKjveTjdwqJplvI9tDlaQqUrVoJ01TYzqaaahtYE0a8jSBoBU0/8IkYAZYLCFEmDHsPcEc2iM/EXvI7+PXdRg613gLsRqnmqeTFfE1yDzVRsWnDeHncFFwPXOHayoNConSG5EI7wKXkQboVcNZpAP6CG9KlsUq6HoqOsaBX/ElcgvuG/MbP02uF+orDZS6RttoUoxFRtRgNdwx3SQGEe+NVmUeVkAAW6yC2IS9zEaFmqH/5JC4SPbGT+g8xvbG3YjPUN9cjsw1D0Umq7bBfqABZMJO/gejD86SFoRcclRsGN4LdiAout6wCimOrsCDhM9k1HUH/ynzyI0fkJdy5djt/H65X2i5tEqaEm2i4Qz/GT0Ig6w3TSVSiN1GoMzDpswjI9ZPXMoCrpbYN5Qvl5XOyKH4Dt15YzHjNOSRIY79JPaYayCj/qejMYTh3nw5tn3wb2l/qI1cWRoe3g/+QL4ZhxvGIqKxFX6MOG6ite3BQzgEMPEb8hNuGvuOfyXPCl2VrkhborU0Lw1rjNeR50h/U2XiKT7aWKi+oegwgUqxpeIztjM3VlwW0od6Sl9lLLFUt9TIG7og+w0PsfVEX7MR6avapfijIXRE1vEz2c3Bz9KD0CR5kLQ8fAr0Rs4aaxraIo+MerwvMdb0TNsWPFBeORf/JqPB26xD4OWDoR9SoXQmWkVzxDDIuAU5gVQw5eEL8UzjR/VNaAdGUCt2SSS4vdwB8UQoM7RYQkLFEuN1/Y13DJWR2YZ1WEuCMHv0XVS7YV/QCFaOZPFZ7MegWc4L7ZQ3SCfDF0AdZIERM5RA9hofmFGioumstiV4CgcCKZ6Q2wTNXE+heOh+SC+ny/ejlTTzDRWNE5ElSAjdi9fEw4Ys9S1lHghoGfsm9uNyuK/i61DX0GWpeqhqYpCujHG3QYt0NfTEJPwZdlXfVHVQ6eTNYdNIlMc5J99YNob/k29IH8IXQQbS0ZiNAGSqcYn5Js6ga7XNwTPlFmE8LbQ62IfbKbQLFYQy5fZyTrSE5jdDwtAKGYw8QnviPvNDw1n1XYUfJtAuhkmHuCpBqySE5oQ8yjtokWilixrGGLL1FQwO7By+GFuvr63aD/so99IvUkPozY3lR8nVw7kyI4XC10FEn2G8inzXtzQ2M0/Gz6LTtPXBa9gLaBONQ4+CJ7m3wqwQGh4gz5NhNFVT2fDC4EQaIFtRDN9v3mDYq9xLMtCCQbHqEsPNCnaSUsJ7Q7i8JtQ1UUv3zNDYcEOvNfw0DccbYKP0lVRHlHk0gZMj44Wj3Cl+t9wzjCkvxhm5Bb7r/YZ1yDW9wwixUvgUtKui44Vyi7rEkJCZD3JJCnUrhdfIJ+T0GKVRGfYbZH0yMhS9r3To/oZVio4koAOjY8Ol6sF7weVSo/CDUH35WmhEIlV32GAy7Nb/QA6bknHB1FBfSnUY9lTmsTJyUAhyPP9MnhOuHeost4z8B/7T3zIMR3boiwy3sffmamhNbd3/6TAmlofa8y2D3cVnoW7hK/JnuV5Mr/mFTDY814v68ugiM2Iub5itvJcUkIBzY+ul+UGcvyGNDHtDYxX/TU2gumkGDzJdfxkZY3pqPmei9Mmqk7CTkoN2RX4KDYL1hYi8JzwwtEAeF8kC+/VrDPWUr/8zzMdWmCVjkrYa+Ai7gOTE4dB6fkNwsxgMzQxny0ioVyyhvoI0NxzWf9SzxobmK1gUGaLOUnyqBstit6SHwV68JK0I4+Hdsjm8JBHUtjZcQLrr1yJVTQvMY02FOlJ1HHYFzeCliF1cEVwoVArdDK8MnZE3Ru6DhfoBBhzpqt9kaIA1MP9jjGiqgvfK1ymJR6GX/Lfga9EZ3hYmQjVCM2KMehOCG5bp/9Y/NNLYVOw+0ll953/z2BzzSWb+EF9BvhiuEn4l1wpvS3zTJhuWIxX1o5EgWtNcwvRAp1WdgR2VeTyLdBY/BO8J/UOe8PmQWz4beQH66TMNOfoK+jEGycRgvxt/aCqCD8o8nInCECWU4a1Sq/DNcIPQsNC6WKF6JOJB+uhX6jcaj2FlsQ1IE8UfGUCGh2Mpcg8+wA+RP4T7hWV5RPhw4r7Wj/REjPrGyBW0EPuO7tXFwP/X8SuyWumeZnFFyBD5ELKGPkaeg0b6qOJSVF/fcNl0CGtgvKvo+L95lEzg4W7CLL6jNDP8IzwytD10JOZWN0DOIzX0I/X9jYOwL6ZBSAX1PcWnCXg21k7ey9cRdsiJ8B/hcqF14cuJM9rbSHkkT2dH5qO7sN3odB0Pzis6WsFE5KY4nW8n3gqVi6jCjUPxyFNQXP8U2azP16GGqabeWNxwTFMGfIEdQMVE9fBWIYtfJe0JqyKbFJbdjn1SW5DFCK5vqK9otGEbTZWQFEVHCgjD27GZso9fKLySXZHD4Z7Kvd9K7NWuRaD+ri6gb452wPqiHXQ0uAjbKj3KEo2I1/nNoi/UKVIuPC2UHn0Hwrr9yGjl619IZZMBu2tYqykGfsJWoFaiR/irgAlPpfvhMpHboWDoe+ypukjfFfHpUvSC4aWplSmsRxSfJis6nsVOyFWEp4I21CryNLwslBd+mVikHYk81x/U3dPrURVmQUvpPErybQE6wzLRupJG+Comh6dFuoYPhJpH34LvurFIU/1e3SXEh940LTdMVHR8hy1Bg8SccJo4UNDLgXD7iC9UPCzGbqsf6F3IAx2vyzIsNUXRJ3pR9fB/Or7GPsmzhWSxXmhSxB++EiIiPxITtdWRY/pZun36J8ZLppfGuPaLoqMN6ABbRcdLvYRkqWN4fWRh+GVodPQD+FfXGLHp/9AtQ46h00ztDN01LvBDmUfTxL7wIPG40Eq2RyZGUsPtw9b4efUuPa/frXutW2VoZLqA7tTnqB4p7zYC82JI6I4wSJwa2hixRfJCdSN0ortWh8zRd9fN0a80TjD9afyqfaUk8BagCxwcPS4dEAZJc8JXI4fC6vCy6BewRUcgXl0fXW9kGFrWZDLU1ziABzYHbRN3w/tFXlgmN41sirRS3Fc+flw9WX9fP1V3VtfdIKBj0BH6z6os5b2wMBGrEcLEY8q2/SdSP2ILD4uEEw20n/Qd9Jm6TvouxnRTG+M57TMl+bYCHeGcaLZUJBySToS/RF6GK4dPRT+Bqboc/Q1dfV0JpBT6Hn2LZCg6smET0DWRFy4QG4t35DGRfyITw2fDjeJ71c312/UddCt0xQ3H0eJopv6R6oHiUwEa46NCPUVO/BH6FhkYaR1eEzHA4tqT+nQ9riuup4xvUGjYoL0OsmBj0ANuimbItUWv9C4MI1J4SPhF9DPoorug36qz6mT9T+NqdDui1VCgANYD/RPGSFlpgyjLOyJvIwfDH8MD42vUGfrh+jK6kTovMhx9Z9ToLyv3kgRE6IjvDO0V60m2cCKyMjI1/E8kBeq1S/S0jtaGdB8NK9BrhvHai+D+/3ScivaWV4gVZG2kWLRYZF04GP0Iqunm6SfrAtpn+j3GBuhgxKu2g3xFx7BE1cgk6b3YOHQloo7eD5sik+LL1QFdXT3QNdRdRWzoeuML3QlFRwoIwvLxRyGfuFhqGy4ZPR05EM6OpENR007/SHdP+0a3x1AbnWdopj37v3n0hA+iW+XX4mS5eqRZtGPkv7Al9glguq765rrn2j36nkbOWBx5qbaBPEXHmESvyHmphDQrlKOoDoWrRzbEJ6lf6NT6n9pk3ULklbGJ8bBui+qpooOD9eLhUDXplTQ33CH6OvI2bIhmwg+aYvrtugPaU7oBhoCxliFd+/f/dPSB7uhr2Smdl4dHRkSnR5hwzdgHUKTN0GfojmknKbd42OjVX1ZbFR11wZTEvIggTZEuhrBoy2jxyPDI0fgI9T7dZ91FraxtjSwzRg2TdatUT6ADBGDHePnwfMkunw9PiYoRTaRKtBG8oRF0Y3XztYt0LsM+o4SImsPgnqKjH4xG8dAoKSyviqyL7olkRHrH3oHHWr9O0C7RNtU/VZrXKf0eNa74ozaYkzgaqSXfkgKhGtFx0U6RLZFr8b7qaf+viusAjuJKov3DzC5gED5yEiByEFEcBkw8MsYGbIPASIARYMSRM/YhQOQoMBhsTM4Zy5KJJh/CZJGDfHAYEEEEG47dnR/6WuKurm5/TdXOTk/P++919+9fWzXOFme+vCAL0e7oR39jZwLhKAHPMNb0DJ140zvwIPS1Kq0ivc9US9wojjuNnWjZnWpk11zbfTfEEjhFTMdiEd2WescGwYPeTpXmdfLGEI6N8mfntIyV77oz/flyDXen8LzwCOtAok3z/hZwA9VCPdUC9TfviHfOfMjbOl868XKLvO2+8sf5Czpx7ALVsSwcamjvHNgQKO7tU61VjDdNdcJZ4huK/3qyhrPG58s11JcsFlDHWQ/6YJSeFHQC44NPvEvqhTfR+06fh6lyjrNWNpT3nBb+Y/4GbjzPTX4jYYF95h0PfBwYQFXmR7XFe+llmka8rNPBaS0T5Xp3q7+U/zcZzc4SH09xkjkc6h54GfjAu6P+quZ4u1QPHCbinEcyTLpOnG8f9e1zxRzCEQX9sKM+GvwocChYWL1RxdUOb7++ADEy1hkni8rdDvrG+NHpzPOQ31rwtS2i3OCqwLrsKqOue8UV2Kr8jQx3wmWMHObG+q/4UmQ74qMY2X9tnoc2BaKCMz1Ui9VB75rqj9GinrNfZokMWcE33P/QHSQS4SzWhzgcor3g8oAINVWldDN117tOfNSXtZ2PZEBMcg74KvtPOQ24j+KuKqy0zVSb4PNARuiqCiqH2C5iS/Ff5HMZEvXle24B/3zfNNmYnSc+nuB6U8HLCkymalpR71NZnlHDsKF4x5knz4id8olbxr/VbS0mwgWsC/E4W9cLZQWahkapBnq4yqs8fQYKSnAqyUuikzPOd8uX5JTmkvKwMmy1/dWCYP1gMU+pcF1TjVOVbRhfKY/IdFFIWuesr6Wvu6zGrtL6koV7TFevIfUGz712+h5xXUmPw7LituwtN4tpcod7hdb08mIs7QSycWzWY0J1gzNCK1RvvUw1UiXMKXghzksut4nyTnXfYt/HTh7C8RIrQbKdr64FE4LdvAjdUseqdaqpBT5CLpI7xTNx2pnks241WYalky4P8byZ6U0P5g2VVkO1X7dTnfRkdMU2GSUTRU852J3hq+RaPpr4qA3D8ZhOCU0KpoXOqER9VA1WDcxxOCtWyytirnhJ7LX2lXT+YIL4qAA/2z2qROhMcBHNcKCep86rbvYlayP7y5ni72KJU8f3k6vEu+wa1fWneMsc9s4Fu4W6qEW6lh6nxum5+IhPlLlkH1FXVnMb++45d/kguEw4RuA/9e+hC9QTvlFb9WO1QkWbw7BZDKEZ9hPH5DrXcx/I24zDKywHafauig2VCJ3yRug5er/SapD9lYXLerKvWCVinMfuIPeSYOw2FiBdnpl/eYVDK0PT1F79sd6mvtNL8TzvKH8VTYRLFeq5u9Y5xPtQp1cNxqPRNbwS1NVU1L/oYvoXNcHshymiqZwmWogkGevucHfJY4TjNZaFy9an14fiQlJ9q5P1Q1VFJ9hz7JWQsomYICKctW45d714Ddk4niOaKqpP6FFor8rQCfqGOqlXYjIvJVNEEXFXbHM2uLHOSt6TrKvBBCxjBnrxodleZ/1cN9VGLTWp0EuEEXclRW9ZzO3tjpE7GeTguG2j9NPQ7lBjdUJf1kX0p3qJPcjSxHVRVHQVj2QP96YzXmSS54LwGIvZ7mp3qLr3RHGzRufWWXo9fsNfihkiwJPFYKe7W9b5ikeTdVVIwEZmq5caOuMl6DAzWFfRe81uaEB43xMery6vOYXc5nIZQwxgOGTaGF3TM6FxKlMr3VxP1lvtJrZCbBaveA2RIt9xlzjtxS3qZQtQ3la3C1QgNNoL1xHmoo7Shc0OHMePic9EOp8lIp087l3Zk3eBO1gRpmIP88TDUD61WUeZpbqbvmm2QQGxS4SJa9yIOc5Zx5WJOThKwu92ph7ltfWSVZgpa4aQNgfsUjaMNLnIXTFBHnM6OhHiDHn+E8VpU3tStfAOeB/qduaVjtPvm2SM5QtFLbGL96AcOETrbkPegazLw0z80lRSH3ofqSs62hzTM/Rrswme8cniIU/mZ0QbJ8G5JAYRjiCtGYz2JEe8JO+5qmdamhX6V33RJrI2or3Yzu/wZnKsk8t5wdP+o8vH1qhZnqsm60GmlFmsPzcHsAmPE46Yw2uK3XKI01cW423hLuGYj9+Y/mq5N18x86XJ0qm6kF0DJ3lXsY8v5kuE49RxvhefEA5FOPLgTS1VhldBf2bizWntM/ftSFZMlBaJfD/30+p1WP7CU6iHzE/5MsDW1je9dipFLzJ/MSf1bHMYy/M64hYfwKUYLss5ZaXHmsNvFHmLMdVsUpneBVXDrDRFzSMdaVfCKl5OLObxvL84KDNlf9GMGQwRjsLoM+1VZdVLTzXzjEdKvrZx7An/ncfyJfyc+E2OlWv4JqphYbTuJ9j+upxKUvf1ftPPhPQ2cwYF6beLN+MZPFLekPfFVdaMUEfAUrxhHqq6Kp/uZk6YFoTkA7sExvPXfBBvx6PEGLlCRopIZomPglAOa5iv1VDK2q0m2VQxMSY3fsCO8OO8IaFeJpZQJRnOV+bw8QwX2hV6qLqmipsbZpEpb66aC/iAXeNTeTj/gT8V8+R68RNrnIPjOwya8jqBau5Uc98MMa3NQJsEnfhJ3oqX40zUlF1kkBdjIQTIB3Upqm+pn1W6vki+PzFzTTFsxBaTgkX5X3isaC+fi7Z8EdynOH2M2+0F/bMqoTsYbQ6QdchcwVNsE+/OLZvEd4kmsp9YzupQZpWEVVjS9tFnqPLuMLnst2akmWVnQHViuRQHfoE/En55nLs5OMLgfZxuyuhcFBeKxnSTaiKxEvuCD+TPWRleRnC5UYTz6dQzvUN17JD1G1f30hNNuH1gJpty9ir+wEbwKH6VRfNB4ndRSXzJalFmFYfNWN9u0EV1ur5uatpjZpNZayeDn/flml1ja/gqcVAs5M8gW5f80BZTTD/dRTcnzxF2t7lnmuK7rDFvwM+yIHvE94he4hX7irjIS+tium1uOustertpZXPbFNPS3sXZrAPnfA+ryquJDeIRj2FVScFCsBO72/t6gM5vuO1in5nL5qgdC3dYXX6JpbBh/FMxWkTzDNolcvBDT7xtduvv9HjT2ra2d01+2xE5y8PD+AZ2ke3m8aKEOM2GEBfvkPdndhTV0af6Dmld29438fYeDmVFeAZLYsgeUw3ZzJuyCvCCIu9H/MqWN6n6A1PHjrAlLZoMOxz2MpdvYQtZfV5QlBeV+d/BoMV80BffsW90pk4mn4NtmG1oe2MW/JPdYZPZFjaGh1PtW83iyLOP1gHAnSaTcirMzrPRtqCdbx9jB/aU7WRD2CWKkzDxBY9gEcRcATiIy20/g3qOibFLbRtbw3p2ACxk19kkNphJfpYy7A+WCgoZ8TGKVGxiapvHJskusu/bz+0ovEyof2AxbApryC/zRXw0iyHFs3Uphg9MXTPBNLG77BTb3KbaJ1iL7WHTWXu2ng3kR3gkd1gp2nFl4zhm15qO5rSZbg/YkbanLYwxMIhtYj1ZO5bOEvlCfpStBESNuWEi9rfTyHOE/cnutfGEJQGPwyzC0IhFM8Pm8ra8C+tEfOQhHHUoBxLMYTPUXrHb7Ch7zf6B+dgsFssi2Jcsgo+l6H4IJeANVZuTeMc+Mt8an02xGXa1nWtr4SfQio1mf2Zl2GqaYzs+l80FncPHXFxsT5s0083+g6yX2/12Ie6A7qw7e5fVYScoYh1eibWmXsVPurSi2EujLPzeKnvJrrHavsKX0IPVZox1YA9YRf4TS4MitBPOC+dQYBWKoTb2tgU8Q5y0x/ZQnLjIxyzx8oppesoEwsHBgW/xuC1g89sky9HBE/aJ/R6XQXUWybIgH5vB/mBHmYEmhMFH3nvhXFvUtrfnbGn07GVbBl9jOlRjPpYBZdkK9g82ku2EP5FlPkjHihhva9oZVmIlfG2f2b7YAl5BIZYJN6EhRV8qsRifw4eELfjCxtge9oSNxAhUNg+m4EQQLAQX4C58yDay8ewG1IIQSsqw0XjK9qEYBWyGFShqW6JH7Bm4BQfpCTGUB++xJMgPQVL8JrajujfBppHnDuS7KCZgQ0iDp2S7ByT7nA1iLyCa4lQAh71YCjfYdRbtR9gRy2MjzP6X6iqcg62wDwpQtEaxH6ASYXBI9SREu5MUqYV98QOsjQMoxpLgNKRC9ltCirNWTMFIyEO+/bT2D6E8P20d7IbDCVN7XEb7pZWEYiksgvNQkpVmR6Blji5AO9EOxMgT+2cchSPxU4zDixRNG2EdJEIS8ZeXvYIZUPY/fGzGBqRHUYzB2TiCbGejwWHwHcyBUbAYMuA1HINuFHWGrB8T6lpYCFvgJFyEE4jLVCwNX5G3sfAFfA/pcA3mQxThEITjBlm8h1GE/VsaibgAf8XGZDkWPoO/wjKa5Q7oA4VzVDTE1UiaWVdciFtwNXnfSTg6wmDoBZ3I92LYTujfB5csOe0GfqS59cbJuA1/wk24hmZYCDpDDLSBDvA5zINZ9D2cNLFkfQ93EZIpuAqP4iFMxgP4mHY17aAtNIKmZD0GBpLnXCAICVA3tJ1muQ4PYjqm4WG8RLUwEhpDfahO9p2hNz2jDGS/PTO7u7mC+wjDIbyMt+hIx0zKoopQEyJo1IFm0AKqQt6c924ivsGbeAp/wev4EO/jHbxHXUn2P/nFiYMSpEcklKM8FDm2jLI3k/h6gFmUJy9o/Iuw5SFfeSA3jXdp5CU2kD5vkSjqPQ1mV26L2fcDZF/JZovlaKfowJwrSJ6ymXn77e3TgM5FjvXb37LPNN1hkMFbu/9a/u+e/x7wf2fZ1/8NqGAYmnpUAAA="))) {
            using(var soundStreamDecomp = new System.IO.MemoryStream()) {
                using(var decompStream = new System.IO.Compression.GZipStream(soundStream, System.IO.Compression.CompressionMode.Decompress)) {
                    decompStream.CopyTo(soundStreamDecomp);
                    using(var finalStream = new System.IO.MemoryStream(soundStreamDecomp.ToArray())) {
                        var player = new System.Media.SoundPlayer(finalStream);
                        player.PlaySync();
                    }
                }
            }
        }
    });

    /*
        Function dbgOut()
        Prints the passed text. You can use DebugView.exe from Microsoft to check the output. It only works if the debugEnabled flag has been set to true.

        Params: [string] text, that is getting printed out
        Return: void / nothing
    */
    vars.dbgOut = (Action<string>) ((text) => {
        if (debugEnabled) {
            print(" «[AER - v" + vars.ver + "]» " + text);
        }
    });
    
    /*
        Function showInfo()
        Shows the passed text in a informational modal (pop-up)
        
        Params: [string] text to show, [string] modal title
        Return: void / nothing
        
    */
    vars.showInfo = (Action<string, string>) ((input, title) => {
        MessageBox.Show(input, "«[AER - v" + vars.ver + "]» Information - " + title, MessageBoxButtons.OK, MessageBoxIcon.Asterisk); 
    });

    vars.init = (Action<ProcessModuleWow64Safe[], Process>) ((mods, proc) => {
        var dll = mods.Single(x => String.Equals(x.ModuleName, "mono.dll", StringComparison.OrdinalIgnoreCase));
        vars.dbgOut("init{} - got " + dll.ModuleName + " at base: " + dll.BaseAddress.ToString("X"));

        // Teleporter.Static
        DeepPointer dpTeleporter = new DeepPointer(dll.ModuleName, 0x1F6964, new int[]{ 0x30, 0xD5C, 0xE90 });
        IntPtr resolvedTeleporter = IntPtr.Zero;
        dpTeleporter.DerefOffsets(proc, out resolvedTeleporter);
        if(resolvedTeleporter == IntPtr.Zero) {
            throw new Exception("dpTeleporter is wrongly initialized");
        }
        vars.dbgOut("init{} - got dpTeleporter at base: " + resolvedTeleporter.ToString("X2"));
        vars.watchers.Add(new MemoryWatcher<bool>(resolvedTeleporter + 0x5A) { Name = "Teleporter.isLoading", FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull });
        vars.watchers.Add(new MemoryWatcher<bool>(resolvedTeleporter + 0x59) { Name = "Teleporter.isTransitioning", FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull });

        // LoadingScreen.Static
        vars.watchers.Add(new MemoryWatcher<bool>(IntPtr.Zero) { Name = "LoadingScreen.isLoading", FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull }); // init watcher to prevent errors if something already checks for it
        new System.Threading.Tasks.Task(
            (Action)(async () => {
                try {
                    do {
                        DeepPointer dPLoadingScreen = new DeepPointer(dll.ModuleName, 0x1F696C, new int[]{ 0x80, 0x90, 0x40, 0x1C, 0x4, 0xC, 0x0 });
                        IntPtr resolvedLoadingScreen = IntPtr.Zero;
                        dPLoadingScreen.DerefOffsets(proc, out resolvedLoadingScreen);
                        if(resolvedLoadingScreen != IntPtr.Zero) {
                            vars.dbgOut("vars.init{} - got dpLoadingScreen at base: " + resolvedLoadingScreen.ToString("X2"));
                            vars.watchers.Remove(vars.watchers["LoadingScreen.isLoading"]);
                            vars.watchers.Add(new MemoryWatcher<bool>(resolvedLoadingScreen + 0x4) { Name = "LoadingScreen.isLoading", FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull });
                            vars.playCustomBleep();
                            break;
                        }
                        await System.Threading.Tasks.Task.Delay(1000, vars.cts.Token).ConfigureAwait(true);
                    } while(vars.cts.Token.IsCancellationRequested == false);
                } catch (Exception ex) {
                    vars.dbgOut("vars.init{} - got an exception: " + ex.ToString());
                }
            })
        ).Start();
    });
}
/*
    shutdown{} runs when the script gets unloaded (disabling autosplitter, closing LiveSplit, changing splits)
*/
shutdown {
    vars.cts.Cancel();
    vars.resetGlobals();
}
/*
    init{} runs if the given process has been found (can occur multiple times during a session; if you reopen the game as an example)
*/
init {
    refreshRate = 1000/500; // cycle every 0.5 seconds
    if(game.Handle == null) {
        throw new Exception("handle invalid");
    }
    vars.dbgOut("init{} - attached autosplitter to game client");

	// reset globals
    vars.resetGlobals();

    vars.init(modules, game);
    refreshRate = 1000/17; // 58 times a second
}
/*
    exit{} runs when the attached process exits/dies
*/
exit {
    vars.cts.Cancel();
    vars.resetGlobals();
}
/*
    update{} always runs
    return false => prevents isLoading{}, gameTime{}, reset{}
*/
update {
    // update memory fields
    vars.watchers.UpdateAll(game);
    foreach(MemoryWatcher watcher in vars.watchers) {
        if(watcher.Changed) {
            vars.dbgOut("update{} - " + watcher.Name + " switched from " + watcher.Old + " to: " + watcher.Current);
        }
    }
}
/*
    isLoading{} only runs when the timer's active (will be skipped if update{}'s returning false)
    return true => pauses the GameTime-Timer till the next tick
*/
isLoading {
    return (vars.watchers["Teleporter.isLoading"].Current.Equals(true) || vars.watchers["LoadingScreen.isLoading"].Current.Equals(true) || vars.watchers["Teleporter.isTransitioning"].Current.Equals(true));
}
