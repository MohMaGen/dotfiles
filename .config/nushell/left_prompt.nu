
def create_top_line [] {

    let home =  $nu.home-path
    let dir = (
        if ($env.PWD | path split | zip ($home | path split) | all { $in.0 == $in.1 }) {
            ($env.PWD | str replace $home "~")
        } else {
            $env.PWD
        }
    )

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    let git_segment = try {
        git branch err+out> /tmp/null
        if $env.LAST_EXIT_CODE < 0 {
            error make {msg: ""}
        }
        let git_branch = git branch | grep "*" | str replace -r '\* (\w*)' '《 $1 》' 
        let git_color = ansi yellow_bold
        $"($git_color)($git_branch)"
    } catch {
        let git_color = ansi white
        let msg = "《 no branch 》"
        $"($git_color)($msg)"
    }

    let jaba_color = ansi green_bold 
    let jaba = $"($jaba_color)蟾蜍"

    let top_line_parts = [
        $path_segment,
        $git_segment,
    ]

    let separator_color = ansi white
    let separator_sign = " 。"
    let separator = $"($separator_color)($separator_sign)"

    $top_line_parts | reduce { |it,acc| $acc + $separator + $it }
}

def create_second_line [] {
    let jaba_ch = "蟾蜍"
    let jaba_color = ansi blue_bold
    let user_tkn = users | str replace -r '(\w*)' '$1'

    $"($jaba_color)\( ($jaba_ch) :: ($user_tkn) \)"
}

export def create_left_prompt [] {
    let top_line = create_top_line
    let second_line = create_second_line

    $top_line + "\n" + $second_line
}
