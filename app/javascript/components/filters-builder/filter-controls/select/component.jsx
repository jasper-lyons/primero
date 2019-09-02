/* eslint-disable camelcase */
import React from "react";
import PropTypes from "prop-types";
import { connect, useSelector } from "react-redux";
import { MenuItem, FormControl, Select } from "@material-ui/core";
import { makeStyles } from "@material-ui/styles";
import { useI18n } from "components/i18n";
import { getOption } from "components/record-form/selectors";
import { isEmpty } from "lodash";
import styles from "./styles.css";
import * as actions from "./action-creators";
import * as Selectors from "./selectors";

const MenuProps = {
  PaperProps: {
    style: {
      maxHeight: 224
    }
  }
};

const SelectFilter = ({
  recordType,
  multiple,
  props,
  selectValues,
  setSelectValue,
  isDate
}) => {
  const css = makeStyles(styles)();
  const i18n = useI18n();
  const { field_name, options, option_strings_source } = props;

  let values = [];

  if (!isEmpty(option_strings_source)) {
    values = useSelector(state =>
      getOption(state, option_strings_source, i18n)
    );
  } else if (Array.isArray(options)) {
    values = options;
  } else {
    values = options[i18n.locale];
  }

  return (
    <div className={css.root}>
      <FormControl variant="outlined" className={css.formControl}>
        <Select
          multiple={multiple}
          value={selectValues && selectValues.length > 0 ? selectValues : []}
          onChange={event => {
            setSelectValue(
              {
                field_name,
                data: event.target.value,
                isDate
              },
              recordType
            );
          }}
          MenuProps={MenuProps}
        >
          {values.map(v => (
            <MenuItem key={v.id} value={v.id}>
              {v.display_name || v.display_text}
            </MenuItem>
          ))}
        </Select>
      </FormControl>
    </div>
  );
};

SelectFilter.propTypes = {
  recordType: PropTypes.string.isRequired,
  multiple: PropTypes.bool,
  props: PropTypes.object,
  options: PropTypes.object,
  field_name: PropTypes.string,
  option_strings_source: PropTypes.string,
  selectValues: PropTypes.oneOfType([PropTypes.array, PropTypes.string]),
  setSelectValue: PropTypes.func,
  isDate: PropTypes.bool
};

const mapStateToProps = (state, obj) => ({
  selectValues: Selectors.getSelect(state, obj)
});

const mapDispatchToProps = {
  setSelectValue: actions.setSelectValue
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(SelectFilter);
