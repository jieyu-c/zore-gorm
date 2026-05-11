{{- if .withCache}}
var (
	barrier{{.upperStartCamelObject}} = syncx.NewSingleFlight()
	stat{{.upperStartCamelObject}}    = cache.NewStat("sqlc:{{.lowerStartCamelObject}}")
{{.cacheKeys}}

)
{{- end}}

var (
	_ = fmt.Sprint
	_ = strings.Replace
)

