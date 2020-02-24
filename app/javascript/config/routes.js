import Login, {
  Dashboard,
  Reports,
  Report,
  PotentialMatches,
  TaskList,
  ExportList,
  Support,
  NotAuthorized,
  NotFound,
  Admin,
  UsersList,
  UsersForm,
  UserGroupsList,
  UserGroupsForm,
  AgenciesList,
  AgenciesForm
} from "../components/pages";
import RecordForm from "../components/record-form";
import RecordList from "../components/record-list";
import { AppLayout, LoginLayout } from "../components/layouts";
import {
  CREATE_RECORDS,
  RECORD_RESOURCES,
  READ_RECORDS,
  READ_REPORTS,
  RESOURCES,
  SHOW_EXPORTS,
  SHOW_TASKS,
  WRITE_RECORDS,
  ADMIN_RESOURCES,
  ADMIN_ACTIONS
} from "../libs/permissions";

import { ROUTES, MODES } from "./constants";

export default [
  {
    layout: LoginLayout,
    routes: [
      {
        path: ROUTES.login,
        component: Login
      },
      {
        path: ROUTES.logout,
        component: Login
      }
    ]
  },
  {
    layout: AppLayout,
    routes: [
      {
        path: ROUTES.dashboard,
        component: Dashboard
      },
      {
        path: "/:recordType(cases|incidents|tracing_requests)/:id/edit",
        component: RecordForm,
        extraProps: {
          mode: MODES.edit
        },
        actions: WRITE_RECORDS
      },
      {
        path: "/:recordType(cases|incidents|tracing_requests)/:module/new",
        component: RecordForm,
        extraProps: {
          mode: MODES.new
        },
        actions: CREATE_RECORDS
      },
      {
        path: "/:recordType(cases|incidents|tracing_requests)/:id",
        component: RecordForm,
        extraProps: {
          mode: MODES.show
        },
        actions: READ_RECORDS
      },
      {
        path: "/cases",
        component: RecordList,
        actions: READ_RECORDS
      },
      {
        path: "/incidents",
        component: RecordList,
        actions: READ_RECORDS
      },
      {
        path: "/tracing_requests",
        component: RecordList,
        actions: READ_RECORDS
      },
      {
        path: ROUTES.key_performance_indicators,
        component: Page.KeyPerformanceIndicators,
        permissionType: "reports",
        permission: ["read", "group_read", "manage"]
      },
      {
        path: ROUTES.reports,
        component: Reports,
        resources: RESOURCES.reports,
        actions: READ_REPORTS
      },
      {
        path: `${ROUTES.reports}/:id`,
        component: Report,
        resources: RESOURCES.reports,
        actions: READ_REPORTS
      },
      {
        path: ROUTES.matches,
        component: PotentialMatches,
        resources: RESOURCES.potential_matches,
        actions: READ_RECORDS
      },
      {
        path: ROUTES.tasks,
        component: TaskList,
        resources: RESOURCES.dashboards,
        actions: SHOW_TASKS
      },
      {
        path: ROUTES.exports,
        component: ExportList,
        resources: RECORD_RESOURCES,
        actions: SHOW_EXPORTS
      },
      {
        path: ROUTES.support,
        component: Support
      },
      {
        path: ROUTES.admin,
        component: Admin,
        resources: ADMIN_RESOURCES,
        actions: ADMIN_ACTIONS,
        exact: false,
        extraProps: {
          routes: [
            {
              path: `${ROUTES.admin_users}/new`,
              component: UsersForm,
              resources: RESOURCES.users,
              extraProps: {
                mode: MODES.new
              }
            },
            {
              path: `${ROUTES.admin_users}/:id/edit`,
              component: UsersForm,
              resources: RESOURCES.users,
              extraProps: {
                mode: MODES.edit
              }
            },
            {
              path: `${ROUTES.admin_users}/:id`,
              component: UsersForm,
              resources: RESOURCES.users,
              extraProps: {
                mode: MODES.show
              }
            },
            {
              path: ROUTES.admin_users,
              component: UsersList,
              resources: RESOURCES.users
            },
            {
              path: `${ROUTES.admin_user_groups}/new`,
              component: UserGroupsForm,
              resources: RESOURCES.user_groups,
              extraProps: {
                mode: MODES.new
              }
            },
            {
              path: `${ROUTES.admin_user_groups}/:id/edit`,
              component: UserGroupsForm,
              resources: RESOURCES.user_groups,
              extraProps: {
                mode: MODES.edit
              }
            },
            {
              path: `${ROUTES.admin_user_groups}/:id`,
              component: UserGroupsForm,
              resources: RESOURCES.user_groups,
              extraProps: {
                mode: MODES.show
              }
            },
            {
              path: ROUTES.admin_user_groups,
              component: UserGroupsList,
              resources: RESOURCES.user_groups
            },
            {
              path: `${ROUTES.admin_agencies}/new`,
              component: AgenciesForm,
              resources: RESOURCES.agencies,
              extraProps: {
                mode: MODES.new
              }
            },
            {
              path: `${ROUTES.admin_agencies}/:id/edit`,
              component: AgenciesForm,
              resources: RESOURCES.agencies,
              extraProps: {
                mode: MODES.edit
              }
            },
            {
              path: `${ROUTES.admin_agencies}/:id`,
              component: AgenciesForm,
              resources: RESOURCES.agencies,
              extraProps: {
                mode: MODES.show
              }
            },
            {
              path: ROUTES.admin_agencies,
              component: AgenciesList,
              resources: RESOURCES.agencies
            }
          ]
        }
      },
      {
        path: ROUTES.not_authorized,
        component: NotAuthorized
      }
    ]
  },
  {
    component: NotFound
  }
];
