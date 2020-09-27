/**
 * @file 個人検査情報
 */
import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';

// 共通コンポーネント
import SectionBar from '../../components/SectionBar';
import Table from '../Table';

const InqPerInspection = ({ consults, perResults }) => (
  <div>
    <SectionBar title="個人情報" />
    <div>
      個人検査情報
    </div>
    <div>
      {(() => {
        if (!Array.isArray(perResults) || perResults.length <= 0) {
          return <span>個人検査情報は存在しません。</span>;
        }
        return (
          <Table>
            <thead>
              <tr>
                <th>検査項目名</th>
                <th>検査結果</th>
                <th>検査日</th>
              </tr>
            </thead>
            <tbody>
              {perResults.map((rec) => (
                <tr key={`${rec.itemcd}-${rec.suffix}`}>
                  <td>{rec.itemname}</td>
                  <td>{rec.shortstc || rec.result}</td>
                  <td>{rec.ispdate && moment(rec.ispdate).format('YYYY/MM/DD')}</td>
                </tr>
              ))}
            </tbody>
          </Table>
        );
      })()}
    </div>
    <div>
      受診歴
    </div>
    <div>
      {(!Array.isArray(consults) || consults.length <= 0) && <span>受診歴は存在しません。</span>}
      {
        Array.isArray(consults) && consults[0] &&
          <div>直近の受診日{moment(consults[0].csldate).format('YYYY/MM/DD')}{consults[0].csname}</div>
      }
      {
        Array.isArray(consults) && consults[1] &&
          <div>１つ前の受診日{moment(consults[1].csldate).format('YYYY/MM/DD')}{consults[1].csname}</div>
      }
    </div>
  </div>
);

InqPerInspection.propTypes = {
  consults: PropTypes.arrayOf(PropTypes.shape()),
  perResults: PropTypes.arrayOf(PropTypes.shape()),
};

InqPerInspection.defaultProps = {
  consults: [],
  perResults: [],
};

export default InqPerInspection;
