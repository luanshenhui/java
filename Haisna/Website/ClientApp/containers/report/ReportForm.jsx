/**
 * @file 帳票用共通コンポーネント
 */
import React from 'react';
import { connect } from 'react-redux';

// 共通コンポーネント
import PageLayout from '../../layouts/PageLayout';
import Button from '../../components/control/Button';

// ガイド画面
import PersonGuide from '../common/PersonGuide';
import OrgGuide from '../common/OrgGuide';

// 帳票用共通モジュール
import { createReport } from '../../modules/report/reportFormModule';

// storeのstateをpropsで参照するための定義
const mapStateToProps = (state) => ({
  notification: state.app.report.reportForm.notification,
  progressDisplay: state.app.report.reportForm.progressDisplay,
});

// actionをpropsで参照するための定義
const mapDispatchToProps = (dispatch) => ({
  onCreate: (values, meta) => {
    dispatch(createReport(values, meta));
  },
});

/**
 * 帳票用ページの共通レイアウト
 * @param {node} WrappedComponent - ページ固有のレイアウト
 * @param {string} title - ページのタイトル
 * @param {string} reportName - 帳票の識別名（API呼び出しに使用
 */
const ReportForm = (WrappedComponent, title, reportName) =>
  connect(mapStateToProps, mapDispatchToProps)((props) => {
    const { notification, progressDisplay } = props;
    return (
      <PageLayout title={title}>
        <form
          onSubmit={props.handleSubmit((values) => {
            // reportNameのフィールドがあればそれを優先する
            const newReportName = values.reportName || reportName;
            // reportNameのフィールドを削除
            const newValues = { ...values };
            delete newValues.reportName;
            props.onCreate(newValues, { reportName: newReportName });
          })}
        >
          <div style={{ display: notification.alertDisplay }}>
            {Array.isArray(notification.message) && notification.message.map((message, i) => <div key={i}>{message}</div>)}
            {!Array.isArray(notification.message) && <div>{notification.message}</div>}
          </div>
          {WrappedComponent && (
            <WrappedComponent {...props} />
          )}
          <div style={{ marginTop: 20 }}>
            <Button type="submit" value="実行" />
          </div>
          <span style={{ display: progressDisplay }} />
        </form>
        <PersonGuide />
        <OrgGuide />
      </PageLayout>
    );
  });

export default ReportForm;
