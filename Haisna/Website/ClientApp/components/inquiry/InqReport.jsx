/**
 * @file 結果参照 レポート
 */
import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import moment from 'moment';

// 共通コンポーネント
import SectionBar from '../../components/SectionBar';
import GenderName from '../common/GenderName';
import Table from '../Table';

import { RESULTTYPE_SENTENCE } from '../../constants/common';

// レイアウト
const PersonGroup = styled.div`
  display: table;
`;
const PerIdField = styled.div`
  display: table-cell;
`;
const PersonField = styled.div`
`;

const InqReport = ({
  visible,
  consult,
  judgements,
  resultsR,
  resultsQ,
}) => (
  <div>
    { visible &&
      <div>
        <SectionBar title="Report" />
        <div>
          受診日：{consult.csldate && moment(consult.csldate).format('YYYY/MM/DD')}　受診コース：{consult.csname}　予約番号：{consult.rsvno}
        </div>
        <PersonGroup>
          <PerIdField>
            {consult.perid}
          </PerIdField>
          <PersonField>
            {consult.lastname}　{consult.firstname}({consult.lastkname}　{consult.firstkname})
          </PersonField>
          <PersonField>
            {consult.birth && moment(consult.birth).format('YYYY/MM/DD')}生　{consult.age}歳　{consult.gender && <GenderName code={consult.gender} />}
          </PersonField>
        </PersonGroup>
        <SectionBar title="判定結果" />
        <div>
          <Table>
            <thead>
              <tr>
                <th>分野</th>
                <th>判定</th>
              </tr>
            </thead>
            {
              Array.isArray(judgements) && judgements.map((rec, index) => (
                <tr key={index.toString()}>
                  <td>{rec.judclassname}</td>
                  <td>{rec.judsname}</td>
                </tr>
              ))
            }
          </Table>
        </div>
        <SectionBar title="検査結果" />
        <div>
          <Table>
            <thead>
              <tr>
                <th>検査分類名</th>
                <th>検査項目名</th>
                <th>検査結果</th>
                <th colSpan="2">コメント</th>
              </tr>
            </thead>
            <tbody>
              {
                Array.isArray(resultsR) && resultsR.map((rec, index) => (
                  <tr key={index.toString()}>
                    <td>{rec.classname}</td>
                    <td>{rec.itemname}</td>
                    <td>{rec.shortstc || rec.result}</td>
                    <td>{rec.rslcmtname1}</td>
                    <td>{rec.rslcmtname2}</td>
                  </tr>
                ))
              }
            </tbody>
          </Table>
        </div>
        <SectionBar title="問診結果" />
        <div>
          <Table>
            <thead>
              <tr>
                <th>問診項目名</th>
                <th>問診回答</th>
              </tr>
            </thead>
            <tbody>
              {
                Array.isArray(resultsQ) && resultsQ.map((rec, index) => (
                  <tr key={index.toString()}>
                    <td>{rec.itemname}</td>
                    <td>
                      {(rec.resulttype === RESULTTYPE_SENTENCE) ? rec.shortstc : rec.result}
                    </td>
                  </tr>
                ))
              }
            </tbody>
          </Table>
        </div>
      </div>
    }
  </div>
);

// propTypes定義
InqReport.propTypes = {
  visible: PropTypes.bool.isRequired,
  consult: PropTypes.shape().isRequired,
  judgements: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  resultsR: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  resultsQ: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

export default InqReport;
