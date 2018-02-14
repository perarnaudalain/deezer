/**
 * Util class to form data
 */
class FormatUtil {
    /**
     * Format duration int64 to String
     * @param duration The duration in integer64
     * @return The duration in String formatted as HH:MM:SS
     */
    static func formatDuration(duration : Int64) -> String {
        var durationTemp = duration;
        if(duration < 0) {
            durationTemp = 0
        }
        
        let seconds = durationTemp % 60
        let minutes = (durationTemp / 60) % 60
        let hours = durationTemp / 3600
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
