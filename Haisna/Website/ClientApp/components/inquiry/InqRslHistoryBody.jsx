/**
 * @file 経年変化 結果表示コンポーネント
 */
import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';

// 共通コンポーネント
import Table from '../Table';
import MessageBanner from '../MessageBanner';

import StrFlgMark from './StdFlgMark';

const InqRslHistoryBody = ({ consults, items, results, messages, onClickCslDate }) => {
  // 特定の受診者情報と検査項目情報から結果を抽出する
  const getResult = (item, consult) => {
    const result = results.filter((rec) => (
      consult.rsvno === rec.rsvno && item.itemcd === rec.itemcd && item.suffix === rec.suffix
    ))[0];
    if (result) {
      return <span><span>{result.result}</span><StrFlgMark code={result.stdflg} /></span>;
    }
    return null;
  };

  return (
    <div>
      { Array.isArray(messages) && <MessageBanner messages={messages} />}
      { consults.length > 0 && items.length > 0 &&
        <Table>
          <thead>
            <tr>
              <th rowSpan="2">検査項目</th>
              {consults.map((rec, i) => (
                <th key={i.toString()} onClick={() => onClickCslDate({ rsvno: rec.rsvno })}>
                  {moment(rec.csldate).format('YYYY/MM/DD')}
                </th>
              ))}
            </tr>
            <tr>
              {consults.map((rec, i) => <th key={i.toString()}>{rec.csname}</th>)}
            </tr>
          </thead>
          <tbody>
            {items.map((item, i) => (
              <tr key={i.toString()}>
                <td>{item.itemname}</td>
                {consults.map((consult, j) => (
                  <td key={j.toString()}>
                    {getResult(item, consult)}
                  </td>
                ))}
              </tr>
            ))}
          </tbody>
        </Table>
      }
    </div>
  );
};

// propTypes定義
InqRslHistoryBody.propTypes = {
  consults: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  items: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  results: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  messages: PropTypes.arrayOf(PropTypes.string),
  onClickCslDate: PropTypes.func.isRequired,
};

// defaultProps定義
InqRslHistoryBody.defaultProps = {
  messages: [],
};

export default InqRslHistoryBody;
