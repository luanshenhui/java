import React from 'react';
import PropTypes from 'prop-types';
import { FieldSet } from '../../components/Field';
import Table from '../../components/Table';

const SpecialJudViewBody1 = ({ dataLeft, dataRight, resultdata }) => (
  <div>
    <FieldSet>
      {dataLeft.length > 0 && (
        <div style={{ float: 'left' }}>
          <Table striped hover style={{ width: 600 }}>
            <thead>
              <tr>
                <th style={{ width: 50, textAlign: 'center' }}>検査項目</th>
                <th style={{ width: 60, textAlign: 'center' }}>項目</th>
                <th style={{ width: 30, textAlign: 'center' }}>検査結果</th>
                <th style={{ width: 30, textAlign: 'center' }}>保健指導</th>
                <th style={{ width: 30, textAlign: 'center' }}>受診勧奨</th>
              </tr>
            </thead>
            <tbody>
              {dataLeft.map((rec, index) => (
                <tr key={index.toString()}>
                  {rec.grpcount !== '' && (<td style={{ textAlign: 'center' }} rowSpan={rec.grpcount}>{rec.grpname}</td>)}
                  <td>{rec.itemname}</td>
                  {rec.hpoint === 0 ?
                    <td style={{ textAlign: 'right' }}><strong>{rec.result}</strong></td> :
                    <td style={{ backgroundColor: '#ffc0cb', textAlign: 'right' }}><strong>{rec.result}</strong></td>
                  }
                  <td style={{ textAlign: 'center' }}>{rec.stdlead}</td>
                  <td style={{ textAlign: 'center' }}>{rec.stdcare}</td>
                </tr>
              ))}
            </tbody>
          </Table>
        </div>
      )}
      {dataRight.length > 0 && (
        <div style={{ float: 'left', marginLeft: 30 }}>
          <Table striped hover style={{ width: 600 }}>
            <thead>
              <tr>
                <th style={{ width: 50, textAlign: 'center' }}>検査項目</th>
                <th style={{ width: 60, textAlign: 'center' }}>項目</th>
                <th style={{ width: 30, textAlign: 'center' }}>検査結果</th>
                <th style={{ width: 30, textAlign: 'center' }}>保健指導</th>
                <th style={{ width: 30, textAlign: 'center' }}>受診勧奨</th>
              </tr>
            </thead>
            <tbody>
              {dataRight.map((rec, index) => (
                <tr key={index.toString()}>
                  {rec.grpcount !== '' && (<td style={{ textAlign: 'center' }} rowSpan={rec.grpcount}>{rec.grpname}</td>)}
                  <td>{rec.itemname}</td>
                  {rec.hpoint === 0 ?
                    <td style={{ textAlign: 'right' }}><strong>{rec.result}</strong></td> :
                    <td style={{ backgroundColor: '#ffc0cb', textAlign: 'right' }}><strong>{rec.result}</strong></td>
                  }
                  <td style={{ textAlign: 'center' }}>{rec.stdlead}</td>
                  <td style={{ textAlign: 'center' }}>{rec.stdcare}</td>
                </tr>
              ))}
            </tbody>
          </Table>
        </div>
      )}
    </FieldSet>
    <div style={{ marginTop: 10 }}>
      {resultdata && resultdata.map((rec, index) => (
        <div key={index.toString()}>{rec.itemname}&nbsp;：&nbsp;<strong>{rec.longstc}</strong></div>
      ))}
    </div>
  </div>
);

// propTypesの定義
SpecialJudViewBody1.propTypes = {
  dataLeft: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  dataRight: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  resultdata: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

export default SpecialJudViewBody1;
