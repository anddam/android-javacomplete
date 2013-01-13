if glob('AndroidManifest.xml') =~ ''
    if filereadable('project.properties')
        if $ANDROID_HOME =~ ''
            let s:androidSdkPath = $ANDROID_HOME
        else
            let s:androidSdkPath = '/opt/android-sdk'
        endif
        vimgrep /target=/j project.properties
        let s:androidTargetPlatform = split(getqflist()[0].text, '=')[1]
        let s:targetAndroidJar = s:androidSdkPath . '/platforms/' . s:androidTargetPlatform . '/android.jar'
        if $CLASSPATH =~ ''
            let $CLASSPATH = s:targetAndroidJar . ':' . $CLASSPATH
        else
            let $CLASSPATH = s:targetAndroidJar
        endif
    end
endif
