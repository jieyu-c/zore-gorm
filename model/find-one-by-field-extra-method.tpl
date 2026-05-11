func (m *default{{.upperStartCamelObject}}Model) formatPrimary(primary any) string {
	return fmt.Sprintf("%s%v", {{.primaryKeyLeft}}, primary)
}

func (m *default{{.upperStartCamelObject}}Model) queryPrimary(ctx context.Context, v any, primary any) error {
	dst := v.(*{{.upperStartCamelObject}})
	row, err := m.Where("{{.originalPrimaryField}} = ?", primary).First(ctx)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return sql.ErrNoRows
		}
		return err
	}

	*dst = row
	return nil
}
