// Entry point for the build script in your package.json
import jquery from 'jquery'
window.jQuery = jquery
window.$ = jquery

require("@nathanvda/cocoon")
import "@hotwired/turbo-rails"
import * as bootstrap from "bootstrap"
