import React from 'react';

import { withRouter } from 'react-router-dom';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import qs from 'qs';
import styled from 'styled-components';

import CircularProgress from '../../../components/control/CircularProgress/CircularProgress';

import PageLayout from '../../../layouts/PageLayout';
import InqReportsInfoHeaderForm from './InqReportsInfoHeaderForm';
import InqReportsInfoBody from './InqReportsInfoBody';
import Pagination from '../../../components/Pagination';


const RedHtml = styled.span`
  color: #ff0000;
`;

const InqReportsInfo = (props) => {
  const { totalcount, conditions, onsearch, history, match, strMessage, isLoading } = props;
  return (
    <div>
      <PageLayout title="成績書発送進捗確認">
        {strMessage !== '' && <RedHtml>{strMessage}</RedHtml>}
        <InqReportsInfoHeaderForm />
        {isLoading && <CircularProgress />}
        {onsearch &&
          <div>
            <InqReportsInfoBody />
            {totalcount > conditions.limit && (
              <Pagination
                startPos={Number.parseInt(conditions.startPos, 10)}
                rowsPerPage={Number.parseInt(conditions.limit, 10)}
                totalCount={totalcount}
                onSelect={(page) => {
                  // ページ番号をクリックした場合はhistory.pushによるページ遷移を行わせる
                  const startPos = ((page - 1) * conditions.limit) + 1;
                  // 結果的にcomponentWillReceivePropsメソッドが呼ばれることにより画面の再描画が行われる
                  history.push({
                    pathname: match.url,
                    search: qs.stringify({ ...conditions, startPos }),
                  });
                }}
              />
            )}
          </div>
        }
      </PageLayout>
    </div>
  );
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  totalcount: state.app.report.reportSendDate.ReportSendDateList.totalcount,
  conditions: state.app.report.reportSendDate.ReportSendDateList.conditions,
  onsearch: state.app.report.reportSendDate.ReportSendDateList.onsearch,
  strMessage: state.app.report.reportSendDate.ReportSendDateList.strMessage,
  isLoading: state.app.report.reportSendDate.ReportSendDateList.isLoading,
});

// propTypesの定義
InqReportsInfo.propTypes = {
  totalcount: PropTypes.number.isRequired,
  conditions: PropTypes.shape().isRequired,
  onsearch: PropTypes.bool.isRequired,
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  strMessage: PropTypes.string.isRequired,
  isLoading: PropTypes.bool.isRequired,
};

// defaultPropsの定義
InqReportsInfo.defaultProps = {
};

export default withRouter(connect(mapStateToProps)(InqReportsInfo));
