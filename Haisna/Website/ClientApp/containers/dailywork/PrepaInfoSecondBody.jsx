import React from 'react';
import Table from '../../components/Table';
import { FieldGroup, FieldSet } from '../../components/Field';
import SectionBar from '../../components/SectionBar';


const PrepaInfoSecondBody = (prepaInfoSecond) => (
  <div style={{ height: '300px', width: '400px', overflow: 'auto' }}>
    <FieldGroup>
      <SectionBar title="二次健診・受診歴・入院歴" />
      <FieldSet>
        <Table>
          <thead>
            <tr height="16">
              <th width="90">受診日</th>
              <th width="160">内容</th>
            </tr>
          </thead>
          <tbody>
            {prepaInfoSecond.prepaInfoSecond && prepaInfoSecond.prepaInfoSecond.map((rec) => (
              <tr key={`prepaInfoSecond-${rec.csldate}-${rec.cscd}-${rec.judcmtstc}`}>
                <td>{rec.csldate}
                </td>
                <td>{rec.cscd}
                </td>
                <td>{rec.judcmtstc}
                </td>
              </tr>
            ))}
          </tbody>
        </Table>
      </FieldSet>
    </FieldGroup>
  </div>
);


export default PrepaInfoSecondBody;
