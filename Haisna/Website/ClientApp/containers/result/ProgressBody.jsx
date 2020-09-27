import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import moment from 'moment';

import { connect } from 'react-redux';
import { withRouter, Link } from 'react-router-dom';

import Table from '../../components/Table';

const Pair = styled.span`
  font-weight: bold;
  color: red;
`;

class ProgressBody extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  // 表示
  handleSubmit(values) {
    const { history, onSubmit } = this.props;
    const params = {};

    params.rsvno = values.rsvno;
    if (values.mode) {
      params.mode = 2;
    }
    params.dayid = String(values.dayid);
    params.csldate = moment(values.csldate).format('YYYY/M/D');
    if (values.code) {
      params.code = values.code;
    }
    params.noprevnext = 1;
    params.dismode = true;
    onSubmit(
      params,
      () => history.push('/contents/result/rslmain'),
    );
  }

  render() {
    const { data, progressName, strRslStatus, loading } = this.props;
    function PrefixInteger(num, length) {
      return (Array(length).join('0') + num).slice(-length);
    }

    function judegement(EntriedJud) {
      switch (EntriedJud) {
        case 0:
          return '○';
        case 1:
          return '●';
        case 2:
          return '';
        case 3:
          return '▲';
        default:
          return '';
      }
    }

    function Rslstatus(status) {
      if (status === 2) {
        return '○';
      }
      if (status === 3) {
        return '●';
      }
      return '▲';
    }

    return (
      <Table striped hover>
        <thead>
          <tr>
            <th>当日ＩＤ</th>
            <th>氏名</th>
            <th>性別</th>
            <th>年齢</th>
            <th>手判</th>
            <th>判定</th>
            <th colSpan="2">自判</th>
            <th>結果</th>
            {progressName && progressName.map((item) => <th key={item.progresscd}>{item.progresssname}</th>)}
          </tr>
        </thead>
        <tbody>
          {data && data.map((item, index) => (
            <tr key={item.rsvno}>
              <td>{PrefixInteger(item.dayid, 4)}</td>
              <td nowrap="nowrap">{item.lastname} {item.firstname}</td>
              <td>{item.gender === 1 ? '男性' : '女性'}</td>
              <td nowrap="nowrap">{parseInt(item.age, 10)}歳</td>
              <td><Link to={`/contents/judgement/interview/top/${item.rsvno}/totaljudview/0/0`} onClick={() => { loading(); }}>{judegement(item.strArrEntriedJudManual)}</Link></td>

              <td nowrap="nowrap">
                <Link to={`/contents/judgement/interview/top/${item.rsvno}/totaljudview/0/0`} onClick={() => { loading(); }}>判定入力</Link>
              </td>
              <td><Link to={`/contents/judgement/interview/top/${item.rsvno}/totaljudview/0/0`} onClick={() => { loading(); }}>{judegement(item.strArrEntriedJud)}</Link></td>
              <td>{item.mensetsustate === '可能' && <Pair alt="自動判定処理実施">✔</Pair>}</td>
              <td nowrap="nowrap">
                <a
                  role="presentation"
                  style={{ color: 'blue', textDecoration: 'underline' }}
                  onClick={() => { this.handleSubmit({ dayid: item.dayid, csldate: item.csldate, rsvno: item.rsvno }); loading(); }}
                >
                  結果入力
                </a>
              </td>
              {progressName.map((rec) => {
                for (let i = 0; i < strRslStatus[index].length; i += 1) {
                  if (strRslStatus[index][i].progresscd === rec.progresscd) {
                    return (
                      <td key={`${rec.progresscd}${item.rsvno}`}>
                        <a
                          role="presentation"
                          style={{ color: 'blue', textDecoration: 'underline' }}
                          onClick={() => { this.handleSubmit({ dayid: item.dayid, csldate: item.csldate, code: rec.progresscd, rsvno: item.rsvno, mode: 2 }); loading(); }}
                        >
                          {Rslstatus(strRslStatus[index][i].status)}
                        </a>
                      </td>
                    );
                  }
                }
                return (<td key={`${rec.progresscd}${item.rsvno}`}>&nbsp;</td>);
              })}
            </tr>
          ))}
        </tbody>
      </Table>
    );
  }
}

// propTypesの定義
ProgressBody.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  progressName: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  strRslStatus: PropTypes.arrayOf(PropTypes.arrayOf(PropTypes.shape())).isRequired,
  history: PropTypes.shape().isRequired,
  onSubmit: PropTypes.func.isRequired,
  loading: PropTypes.func.isRequired,
};


const mapStateToProps = (state) => ({
  data: state.app.result.result.progressList.data,
  conditions: state.app.result.result.progressList.conditions,
  totalCount: state.app.result.result.progressList.totalCount,
  progressName: state.app.result.result.progressList.progressName,
  strRslStatus: state.app.result.result.progressList.strRslStatus,
});

export default withRouter(connect(mapStateToProps)(ProgressBody));
