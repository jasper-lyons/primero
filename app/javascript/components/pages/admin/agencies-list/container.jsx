import React from "react";
import { useSelector, useDispatch } from "react-redux";
import { fromJS } from "immutable";
import { Button, Grid, makeStyles, useMediaQuery } from "@material-ui/core";
import AddIcon from "@material-ui/icons/Add";
import { Link } from "react-router-dom";

import { useI18n } from "../../../i18n";
import IndexTable from "../../../index-table";
import { PageHeading, PageContent } from "../../../page";
import { ROUTES } from "../../../../config";
import { usePermissions, getListHeaders } from "../../../user";
import { CREATE_RECORDS, RESOURCES } from "../../../../libs/permissions";
import { headersToColumns } from "../utils";
import { Filters as AdminFilters } from "../components";
import { useThemeHelper } from "../../../../libs";
import styles from "../styles.css";

import { fetchAgencies } from "./action-creators";
import { NAME, DISABLED } from "./constants";
import { getFilters } from "./utils";
import NAMESPACE from "./namespace";

const Container = () => {
  const i18n = useI18n();
  const dispatch = useDispatch();
  const canAddAgencies = usePermissions(NAMESPACE, CREATE_RECORDS);
  const recordType = RESOURCES.agencies;
  const css = makeStyles(styles)();
  const { theme } = useThemeHelper(styles);
  const mobileDisplay = useMediaQuery(theme.breakpoints.down("sm"));

  const headers = useSelector(state =>
    getListHeaders(state, RESOURCES.agencies)
  );

  const columns = headersToColumns(headers, i18n);

  const tableOptions = {
    recordType,
    columns,
    options: {
      selectableRows: "none"
    },
    defaultFilters: fromJS({
      per: 20,
      page: 1
    }),
    onTableChange: fetchAgencies,
    localizedFields: ["name", "description"]
  };

  const filterProps = {
    clearFields: [DISABLED],
    filters: getFilters(i18n),
    onSubmit: data => dispatch(fetchAgencies({ options: data })),
    defaultFilters: {
      [DISABLED]: ["false"]
    }
  };

  const renderNewText = !mobileDisplay ? i18n.t("buttons.new") : null;

  const newAgencyBtn = canAddAgencies ? (
    <Button
      to={ROUTES.admin_agencies_new}
      component={Link}
      color="primary"
      className={css.showActionButton}
    >
      <AddIcon />
      {renderNewText}
    </Button>
  ) : null;

  return (
    <>
      <PageHeading title={i18n.t("agencies.label")}>{newAgencyBtn}</PageHeading>
      <PageContent>
        <Grid container spacing={2}>
          <Grid item xs={12} sm={9}>
            <IndexTable {...tableOptions} />
          </Grid>
          <Grid item xs={12} sm={3}>
            <AdminFilters {...filterProps} />
          </Grid>
        </Grid>
      </PageContent>
    </>
  );
};

Container.displayName = NAME;

Container.propTypes = {};

export default Container;
