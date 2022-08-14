pure_config_wrapper <- function(.config_label, .test = FALSE){
        if (Sys.getenv("OS") == "Windows_NT") {
                config_label <- paste0("MS_",.config_label)
        }
        if (.test == TRUE) {
                config::get(config_label, file = Sys.getenv("R_CONFIG_FILE", "config_test.yml"))
        } else {
                config::get(config_label, file = Sys.getenv("R_CONFIG_FILE", "config.yml"))
        }

}
