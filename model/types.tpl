type (
	{{.lowerStartCamelObject}}Model interface{
		{{.method}}
	}

	default{{.upperStartCamelObject}}Model struct {
		gorm.Interface[{{.upperStartCamelObject}}]
{{- if .withCache}}
		cache cache.Cache
{{- end}}
	}

	{{.upperStartCamelObject}} struct {
		{{.fields}}
	}
)
