import React from 'react';
import PropTypes from 'prop-types';
import qs from 'qs';
import { connect } from 'react-redux';
import CircularProgress from '../../components/control/CircularProgress/CircularProgress';
import Pagination from '../../components/Pagination';
import PageLayout from '../../layouts/PageLayout';
import PerBillSearchBody from './PerBillSearchBody';
import PerBillSearchHeaderForm from './PerBillSearchHeaderForm';

const PerBillSearch = (props) => {
  const { totalCount, conditions, history, match, isLoading } = props;
  return (
    <PageLayout title="個人請求書の検索">
      {isLoading && <CircularProgress />}
      <PerBillSearchHeaderForm />
      <br />
      <div>
        <PerBillSearchBody />
        {conditions.pageMaxLine > 0 && totalCount > conditions.pageMaxLine && (
          <Pagination
            startPos={((conditions.page - 1) * conditions.pageMaxLine) + 1}
            rowsPerPage={Number(conditions.pageMaxLine)}
            totalCount={totalCount}
            onSelect={(page) => {
              // ページ番号をクリックした場合はhistory.pushによるページ遷移を行わせる
              history.push({
                pathname: match.url,
                search: qs.stringify({ ...conditions, page }),
              });
            }}
          />
        )}
      </div>
    </PageLayout>);
};
// propTypesの定義
PerBillSearch.propTypes = {
  conditions: PropTypes.shape().isRequired,
  totalCount: PropTypes.number,
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  isLoading: PropTypes.bool.isRequired,
};

PerBillSearch.defaultProps = {
  totalCount: null,
};
// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  totalCount: state.app.bill.perBill.perBillList.totalCount,
  conditions: state.app.bill.perBill.perBillSearch.conditions,
  isLoading: state.app.bill.perBill.perBillSearch.conditions.isLoading,
});

export default connect(mapStateToProps)(PerBillSearch);
