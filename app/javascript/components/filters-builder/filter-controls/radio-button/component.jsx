/* eslint-disable camelcase */
import React from "react";
import PropTypes from "prop-types";
import { connect, useSelector } from "react-redux";
import { makeStyles } from "@material-ui/styles";
import { Radio, RadioGroup, FormControlLabel } from "@material-ui/core";
import { RadioButtonChecked, RadioButtonUnchecked } from "@material-ui/icons";
import { useI18n } from "components/i18n";
import { getOption } from "components/record-form/selectors";
import { isEmpty } from "lodash";
import styles from "./styles.css";
import * as actions from "./action-creators";
import * as Selectors from "./selectors";

const RadioButton = ({
  recordType,
  inline,
  props,
  radioButton,
  setRadioButton
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
    <div className={css.Root}>
      <RadioGroup
        aria-label={field_name}
        name={field_name}
        value={radioButton}
        onChange={e =>
          setRadioButton(
            {
              field_name,
              data: e.target.value
            },
            recordType
          )
        }
        row={inline}
      >
        {values.map(f => (
          <FormControlLabel
            key={f.id}
            value={f.id.toString()}
            control={
              <Radio
                className={css.Checked}
                icon={<RadioButtonUnchecked fontSize="small" />}
                checkedIcon={<RadioButtonChecked fontSize="small" />}
              />
            }
            label={f.display_name || f.display_text}
          />
        ))}
      </RadioGroup>
    </div>
  );
};

RadioButton.propTypes = {
  recordType: PropTypes.string.isRequired,
  props: PropTypes.object.isRequired,
  options: PropTypes.object,
  inline: PropTypes.bool,
  field_name: PropTypes.string,
  option_strings_source: PropTypes.string,
  radioButton: PropTypes.string,
  setRadioButton: PropTypes.func
};

const mapStateToProps = (state, obj) => ({
  radioButton: Selectors.getRadioButtons(state, obj)
});

const mapDispatchToProps = {
  setRadioButton: actions.setRadioButton
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(RadioButton);
