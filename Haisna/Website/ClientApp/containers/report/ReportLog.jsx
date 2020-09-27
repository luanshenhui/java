import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import moment from 'moment';
import styled from 'styled-components';
import { Field, reduxForm, blur } from 'redux-form';

import PageLayout from '../../layouts/PageLayout';
import ListHeaderFormBase from '../../components/common/ListHeaderFormBase';

import Button from '../../components/control/Button';
import DatePicker from '../../components/control/datepicker/DatePicker';
import DropDown from '../../components/control/dropdown/DropDown';
import Table from '../../components/Table';

import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import { initializeDrlList, getRepListRequest } from '../../modules/report/reportLogModule';


const TotalCount = styled.span`
  font-weight: bold;
  color: #ff6600;
`;
const Gray = styled.td`
  font-weight: bold;
  color: #999999;
`;
const Red = styled.td`
  font-weight: bold;
  color: #ff0000;
`;
const prtStatusItems = [{ value: '', name: ' ' }, { value: 0, name: '印刷中' }, { value: 1, name: '正常終了' }, { value: 2, name: '異常終了' }];
const SortOldItems = [{ value: false, name: '新しい順' }, { value: true, name: '古い順' }];

const print = (seq) => {
  open(`/api/v1/reports/${seq}`);
};

const ReportLog = (props) => {
  const { totalCount, data, conditions } = props;
  return (
    <PageLayout title="印刷ログの表示" >
      <ListHeaderFormBase {...props} >
        <FieldGroup>
          <FieldSet>
            <FieldItem>印刷日：</FieldItem>
            <Field name="printDate" component={DatePicker} id="printDate" />
            <Field name="prtStatus" component={DropDown} id="prtStatus" items={prtStatusItems} />
            <Field name="sortOld" component={DropDown} id="SortOld" items={SortOldItems} />
            <Button type="submit" value="表示" />
          </FieldSet>
        </FieldGroup>
      </ListHeaderFormBase>
      {totalCount &&
        <p>「<TotalCount>{moment(conditions.printDate).format('YYYY/M/D')}以降の印刷ログ」</TotalCount>の検索結果は<TotalCount>{data.length}</TotalCount>件ありました。</p>
      }
      {data.length > 0 &&
        <Table striped hover>
          <thead>
            <tr>
              <th>プリントＳＥＱ</th>
              <th>印刷開始日時</th>
              <th>帳票コード</th>
              <th>帳票名</th>
              <th>ステータス</th>
              <th>印刷終了時間</th>
              <th>出力枚数</th>
              <th>ユーザＩＤ</th>
              <th>ユーザ名</th>
              <th>帳票一時ファイル名</th>
            </tr>
          </thead>
          <tbody>
            {data.map((rec) => (
              <tr key={rec.printseq}>
                <td style={{ textAlign: 'right' }}>{rec.printseq}</td>
                <td>
                  {rec.printdate &&
                    moment(rec.printdate).format('YYYY/MM/DD h:mm:ss')
                  }
                </td>
                <td style={{ textAlign: 'right' }}>{rec.reportcd}</td>
                <td>{rec.reportname}</td>
                {
                  (() => {
                    switch (rec.status) {
                      case 1:
                        return <td>正常終了</td>;
                      case 2:
                        return <Red>異常終了</Red>;
                      case 0:
                        return <Gray>印刷中</Gray>;
                      default:
                        return <td>正常終了</td>;
                    }
                  })()
                }
                <td>
                  {rec.enddate &&
                    moment(rec.enddate).format('YYYY/MM/DD h:mm:ss')
                  }
                </td>
                <td style={{ textAlign: 'right' }}>{rec.count}</td>
                <td>{rec.userid}</td>
                <td>{rec.username}</td>
                <td><a role="presentation" style={{ color: 'blue', textDecoration: 'underline' }} onClick={() => { print(rec.printseq); }}>{rec.reporttempid}</a></td>
              </tr>
            ))}
          </tbody>
        </Table>
      }
    </PageLayout>
  );
};


// propTypesの定義
ReportLog.propTypes = {
  totalCount: PropTypes.number,
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  conditions: PropTypes.shape().isRequired,
};

// defaultPropsの定義
ReportLog.defaultProps = {
  totalCount: null,
};

const ReportLogForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: 'ReportLogForm',
  enableReinitialize: true,
})(ReportLog);

// componentのプロパティとして紐付けるstate(状態)の定義
const mapStateToProps = (state) => ({
  conditions: state.app.report.reportLog.reportLogList.conditions,
  totalCount: state.app.report.reportLog.reportLogList.totalCount,
  data: state.app.report.reportLog.reportLogList.data,
  initialValues: {
    printDate: state.app.report.reportLog.reportLogList.conditions.printDate,
    prtStatus: state.app.report.reportLog.reportLogList.conditions.prtStatus,
    sortOld: state.app.report.reportLog.reportLogList.conditions.sortOld,
  },
});

// componentのプロパティとして紐付けるアクション(action)の定義
const mapDispatchToProps = (dispatch) => ({
  initializeList: () => {
    dispatch(initializeDrlList());
  },
  onSearch: (conditions) => {
    let params = {};
    if (!conditions.printDate) {
      const printDate = moment().format('YYYY/M/D');
      params = { ...conditions, printDate };
      dispatch(blur('ReportLogForm', 'printDate', printDate));
    } else {
      params = { ...conditions };
    }
    dispatch(getRepListRequest(params));
  },
});
export default connect(mapStateToProps, mapDispatchToProps)(ReportLogForm);
