import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import styled from 'styled-components';
import Table from '../../components/Table';
import { getHistoryRslLifeRequest, getHistoryRslSelfRequest } from '../../modules/judgement/interviewModule';

const Wrapper = styled.div`
  font-size: 1.6em;
  color: #0066cc;
`;
const TdWrapper1 = styled.td`
  background-color: #ffffff;
  width:25%;
`;
const TdWrapper2 = styled.td`
  background-color: #90f0aa;
  width:18.75%;
`;
const TdWrapper3 = styled.td`
  background-color: #ffffcc;
  width:18.75%;
`;
const TdWrapper4 = styled.td`
  background-color: #ffdead;
  width:18.75%;
`;
const TdWrapper5 = styled.td`
  background-color: #eeeeee;
  width:18.75%;
`;

const GetdataLife = (dataSelf) => {
  const lifecount = [];
  const liferesult1 = [];
  const liferesult2 = [];
  const liferesult3 = [];
  const liferesult4 = [];
  const reslife = [];
  dataSelf.map((rec) => (
    ((rec.suffix) === '04' && (rec.result) !== null) && lifecount.push(rec.result)
  ));
  dataSelf.map((rec) => (
    ((rec.suffix) === '01' && (rec.result) !== null) && liferesult1.push(rec.result)
  ));
  dataSelf.map((rec) => (
    ((rec.suffix) === '02' && (rec.result) !== null) && liferesult2.push(rec.result)
  ));
  dataSelf.map((rec) => (
    ((rec.suffix) === '03' && (rec.result) !== null) && liferesult3.push(rec.result)
  ));
  dataSelf.map((rec) => (
    ((rec.suffix) === '04' && (rec.result) !== null) && liferesult4.push(rec.result)
  ));

  for (let i = 0; i < lifecount.length; i += 1) {
    const reslifecousult = [];
    reslifecousult.push(<TdWrapper1 key={i + 1}>最近気になること</TdWrapper1>);
    reslifecousult.push(<TdWrapper2 key={i + 2}>&nbsp;</TdWrapper2>);
    reslifecousult.push(<TdWrapper3 key={i + 3}>&nbsp;</TdWrapper3>);
    reslifecousult.push(<TdWrapper4 key={i + 4}>&nbsp;</TdWrapper4>);
    reslife.push(<tr key={i + 5}>{reslifecousult}<TdWrapper5>{liferesult1[i]}{liferesult2[i]}{liferesult3[i]}{liferesult4[i]}</TdWrapper5></tr>);
  }
  return reslife;
};

const GetdataSelf = (dataSelf) => {
  const liferesult1 = [];
  const liferesult2 = [];
  const liferesult3 = [];
  const liferesult4 = [];
  const selfcount = Math.trunc(dataSelf.length / 4);
  const resself = [];

  dataSelf.map((rec) => (
    ((rec.suffix) === '01' && (rec.result) !== null) && liferesult1.push(rec.result)
  ));
  dataSelf.map((rec) => (
    ((rec.suffix) === '02' && (rec.result) !== null) && liferesult2.push(rec.result)
  ));
  dataSelf.map((rec) => (
    ((rec.suffix) === '03' && (rec.result) !== null) && liferesult3.push(rec.result)
  ));
  dataSelf.map((rec) => (
    ((rec.suffix) === '04' && (rec.result) !== null) && liferesult4.push(rec.result)
  ));

  for (let j = 0; j < selfcount; j += 1) {
    resself.push(<tr key={j}><td>{liferesult1[j]}</td><td>{liferesult2[j]}</td><td>{liferesult3[j]}</td><td>{liferesult4[j]}</td></tr>);
  }
  return resself;
};

class MonshinNyuryokuBody extends React.Component {
  constructor(props) {
    super(props);
    const { match } = this.props;
    this.rsvno = match.params.rsvno;
  }
  componentDidMount() {
    const { onLoad, match } = this.props;
    onLoad(match.params);
  }

  render() {
    const { dataLife, dataSelf } = this.props;
    return (
      <div>
        <Table striped hover>
          <thead>
            <tr>
              <th>質問内容</th>
              <th colSpan="4">回答内容</th>
            </tr>
          </thead>
          <tbody>
            {dataLife && dataLife.map((rec, index) => (
              <tr key={index.toString()}>
                <TdWrapper1>{rec.itemqname}</TdWrapper1>
                {(rec.questionrank) === 1 ? <TdWrapper2>{rec.result}{rec.unit}</TdWrapper2> : <TdWrapper2>&nbsp;</TdWrapper2>}
                {(rec.questionrank) === 2 ? <TdWrapper3>{rec.result}{rec.unit}</TdWrapper3> : <TdWrapper3>&nbsp;</TdWrapper3>}
                {(rec.questionrank) === 3 ? <TdWrapper4>{rec.result}{rec.unit}</TdWrapper4> : <TdWrapper4>&nbsp;</TdWrapper4>}
                {(rec.questionrank) === null ? <TdWrapper5>{rec.result}{rec.unit}</TdWrapper5> : <TdWrapper5>&nbsp;</TdWrapper5>}
              </tr>
            ))}
            {GetdataLife(dataSelf)}
          </tbody>
        </Table>
        <div style={{ height: '20px' }} />
        <Table striped hover style={{ width: '500px' }}>
          <thead>
            <tr>
              { /* TODO 自覚症状ウインドウ呼び出し */ }
              { /* <td><Wrapper><Link to="/contents/interview/jikakushoujyou/">自覚症状</Link></Wrapper></td> */ }
              <td><Wrapper><a href="#">自覚症状</a></Wrapper></td>
            </tr>
          </thead>
          <tbody>
            {GetdataSelf(dataSelf)}
          </tbody>
        </Table>
      </div>
    );
  }
}

MonshinNyuryokuBody.propTypes = {
  match: PropTypes.shape().isRequired,
  onLoad: PropTypes.func.isRequired,
  dataLife: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  dataSelf: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  dataLife: state.app.judgement.interview.historyRslList.dataLife,
  dataSelf: state.app.judgement.interview.historyRslList.dataSelf,

});
const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    const { rsvno } = params;
    if (rsvno === undefined) {
      return;
    }
    let grpcd = 'X030';
    const hiscount = 1;
    const lastdspmode = 2;
    const csgrp = 'CSC01';
    let getseqmode = 2;
    dispatch(getHistoryRslLifeRequest({ ...params, hiscount, grpcd, lastdspmode, csgrp, getseqmode }));

    grpcd = 'X025';
    getseqmode = 1;
    dispatch(getHistoryRslSelfRequest({ ...params, hiscount, grpcd, lastdspmode, csgrp, getseqmode }));
  },
});
export default withRouter(connect(mapStateToProps, mapDispatchToProps)(MonshinNyuryokuBody));

