func (m *default{{.upperStartCamelObject}}Model) FindOne(ctx context.Context, {{.lowerStartCamelPrimaryKey}} {{.dataType}}) (*{{.upperStartCamelObject}}, error) {
{{- if .withCache}}
	{{.cacheKey}}
	var resp {{.upperStartCamelObject}}
	err := m.cache.TakeCtx(ctx, &resp, {{.cacheKeyVariable}}, func(v any) error {
		dst := v.(*{{.upperStartCamelObject}})
		row, er := m.Where("{{.originalPrimaryKey}} = ?", {{.lowerStartCamelPrimaryKey}}).First(ctx)
		if er != nil {
			if errors.Is(er, gorm.ErrRecordNotFound) {
				return sql.ErrNoRows
			}
			return er
		}

		*dst = row
		return nil
	})

	if err != nil {
		if errors.Is(err, sql.ErrNoRows) || errors.Is(err, gorm.ErrRecordNotFound) || m.cache.IsNotFound(err) {
			return nil, ErrNotFound
		}

		return nil, err
	}

	return &resp, nil
{{- else}}
	row, err := m.Where("{{.originalPrimaryKey}} = ?", {{.lowerStartCamelPrimaryKey}}).First(ctx)
	switch {
	case err == nil:
		return &row, nil
	case errors.Is(err, gorm.ErrRecordNotFound):
		return nil, ErrNotFound
	default:
		return nil, err
	}
{{- end}}
}
