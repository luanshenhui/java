import React from 'react';
import Table from '../../components/Table';
import { FieldGroup, FieldSet } from '../../components/Field';
import SectionBar from '../../components/SectionBar';


const PrepaInfoDiseaseBody = (prepaInfoDisease) => (
  <div>
    <div>
      <SectionBar title="既往歴" />
    </div>
    <div style={{ height: '300px', width: '689px', overflow: 'auto' }}>
      <FieldGroup>
        <FieldSet>
          <Table>
            <thead>
              <tr height="16">
                <th>病名</th>
                <th>罹患年齢</th>
                <th>治癒状態</th>
              </tr>
            </thead>
            <tbody>
              {prepaInfoDisease && prepaInfoDisease.prepaInfoDisease.map((rec, index) => (
                <tr key={rec.key}>
                  <td style={{ background: index % 2 === 0 ? '' : '#e0ffff' }} >{rec.dspName}
                  </td>
                  <td style={{ background: index % 2 === 0 ? '' : '#e0ffff' }} >{rec.dspAge}
                  </td>
                  <td style={{ background: index % 2 === 0 ? '' : '#e0ffff' }} >{rec.dspStat}
                  </td>
                </tr>
              ))}
            </tbody>
          </Table>
        </FieldSet>
      </FieldGroup>
    </div>
  </div>
);


export default PrepaInfoDiseaseBody;
