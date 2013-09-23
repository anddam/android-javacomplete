if glob('AndroidManifest.xml') =~ ''
    if filereadable('project.properties') 
        let s:androidSdkPath = '/opt/android-sdk'
        " the following line uses external tools and is less portable
        "let s:androidTargetPlatform = system('grep target= project.properties | cut -d \= -f 2')
        vimgrep /target=/j project.properties
        let s:androidTargetPlatform = split(getqflist()[0].text, '=')[1] 
        let s:tmp_target = split(s:androidTargetPlatform, ':')

        if len(s:tmp_target) > 1
            let s:androidTargetPlatform = 'android-' . s:tmp_target[len(s:tmp_target)-1]
        endif
        let s:targetAndroidJar = s:androidSdkPath . '/platforms/' . s:androidTargetPlatform . '/android.jar'
        if $CLASSPATH =~ ''
            let $CLASSPATH = s:targetAndroidJar . ':' . $CLASSPATH
        else
            let $CLASSPATH = s:targetAndroidJar
        endif
        if exists('g:add_libs_to_classpath')
            if isdirectory('libs')
                let s:extra_libs = split(globpath('libs', '*.jar'), '\n')
                let c = 0
                while c < len(s:extra_libs)
                    let $CLASSPATH = fnamemodify(s:extra_libs[c], ':p') . ':' . $CLASSPATH
                    let c += 1
                endwhile
            endif
        endif
    endif
endif
