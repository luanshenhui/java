import React from 'react';
import Table from '../../components/Table';
import { FieldGroup, FieldSet } from '../../components/Field';
import SectionBar from '../../components/SectionBar';


const PrepaInfoReexaminBody = (prepaInfoReexamin) => (
  <div style={{ height: '300px', width: '400px', overflow: 'auto' }}>
    <FieldGroup>
      <SectionBar title="再検査項目" />
      <FieldSet>
        <Table>
          <thead>
            <tr height="16">
              <th width="120">健診項目名</th>
              <th width="180">健診結果</th>
            </tr>
          </thead>
          <tbody>
            {prepaInfoReexamin.prepaInfoReexamin && prepaInfoReexamin.prepaInfoReexamin.map((rec) => (
              <tr key={`prepaInfoReexamin-${rec.csldate}-${rec.cscd}`}>
                <td>{rec.csldate}
                </td>
                <td>{rec.cscd}
                </td>
              </tr>
            ))}
          </tbody>
        </Table>
      </FieldSet>
    </FieldGroup>
  </div>
);


export default PrepaInfoReexaminBody;
