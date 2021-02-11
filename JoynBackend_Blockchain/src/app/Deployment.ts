export function checkUrl() {
       return window.location.origin == "http://localhost:4200" ? "http://localhost:8088"
       : window.location.origin == "https://localhost:4200" ? "http://localhost:8088"
       : window.location.origin == "http://localhost:8088" ? "http://localhost:8088"
       : window.location.origin == "http://167.71.239.221:8088" ? `${window.location.protocol}//167.71.239.221:8088`
       : window.location.origin == "https://167.71.239.221:8088" ? `${window.location.protocol}//167.71.239.221:8088`
       : 'Invalid call';
}