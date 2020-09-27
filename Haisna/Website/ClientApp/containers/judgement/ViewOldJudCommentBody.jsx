import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import moment from 'moment';
import Table from '../../components/Table';

// 受診日情報
const CslDetaill = ({ data, rec, index }) => {
  const resCslResult = [];
  let bakCslDate = '';
  let bakCsCd = '';
  if (index && index > 0) {
    bakCslDate = data[index - 1].csldate;
    bakCsCd = data[index - 1].cscd;
  }
  // 受診日が変わった
  if (bakCslDate !== rec.csldate) {
    resCslResult.push(<td key={index + 1}>{moment(rec.csldate).format('YYYY/MM/DD')}</td>);
    resCslResult.push(<td key={index + 2}>{rec.csname}</td>);
  } else {
    resCslResult.push(<td key={index + 3}>&nbsp;</td>);
    // 受診コースが変わった
    if (bakCsCd !== rec.cscd) {
      resCslResult.push(<td key={index + 4}>rec.csname</td>);
    } else {
      resCslResult.push(<td key={index + 5}>&nbsp;</td>);
    }
  }
  return resCslResult;
};

// 総合コメント情報
const ViewOldJudCommentBody = ({ totalJudCmtData }) => (
  <Table striped hover>
    <thead>
      <tr>
        <th>受診日</th>
        <th>コース</th>
        <th>コメント</th>
      </tr>
    </thead>
    <tbody>
      {totalJudCmtData && totalJudCmtData.map((rec, index) => (
        <tr key={index.toString()}>
          <CslDetaill data={totalJudCmtData} rec={rec} index={index} />
          <td>{rec.judcmtstc}</td>
        </tr>
      ))}
    </tbody>
  </Table>
);

// propTypesの定義
ViewOldJudCommentBody.propTypes = {
  totalJudCmtData: PropTypes.arrayOf(PropTypes.shape()),
};

const mapStateToProps = (state) => ({
  totalJudCmtData: state.app.judgement.interview.viewOldJudCommentList.totalJudCmtData,
});

ViewOldJudCommentBody.defaultProps = {
  totalJudCmtData: [],
};

export default connect(mapStateToProps)(ViewOldJudCommentBody);
