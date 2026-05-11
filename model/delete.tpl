func (m *default{{.upperStartCamelObject}}Model) Delete(ctx context.Context, {{.lowerStartCamelPrimaryKey}} {{.dataType}}) error {
{{- if .withCache}}
	{{- if .containsIndexCache}}
	data, err := m.FindOne(ctx, {{.lowerStartCamelPrimaryKey}})
	if err != nil {
		return err
	}

	{{end}}
	{{.keys}}
{{- end}}
{{- if and .withCache .containsIndexCache}}
	_, err = m.Where("{{.originalPrimaryKey}} = ?", {{.lowerStartCamelPrimaryKey}}).Delete(ctx)
{{- else}}
	_, err := m.Where("{{.originalPrimaryKey}} = ?", {{.lowerStartCamelPrimaryKey}}).Delete(ctx)
{{- end}}
	if err != nil {
		return err
	}
{{- if .withCache}}

	return m.cache.DelCtx(ctx, {{.keyValues}})
{{- else}}

	return nil
{{- end}}
}
