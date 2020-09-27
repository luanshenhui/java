import React from 'react';
import Table from '../../components/Table';
import { FieldGroup, FieldSet } from '../../components/Field';
import SectionBar from '../../components/SectionBar';

const PrepaInfoCmntHisBody = (prepaInfoCmntHis) => (
  <div>
    <div>
      <SectionBar title="前回総合コメント" />
    </div>
    <div style={{ height: '300px', width: '689px', overflow: 'auto' }}>
      <FieldGroup>
        <FieldSet>
          <Table>
            <thead>
              <tr height="16">
                <th width="100" >受診日</th>
                <th >受診コース</th>
                <th >コメント</th>
              </tr>
            </thead>
            <tbody>
              {prepaInfoCmntHis && prepaInfoCmntHis.prepaInfoCmntHis.map((rec, index) => (
                <tr key={`prepaInfoCmntHis-${rec.csldate}-${rec.cscd}-${rec.judcmtstc}`}>
                  <td style={{ background: index % 2 === 0 ? '' : '#e0ffff' }} >{rec.csldate}
                  </td>
                  <td style={{ background: index % 2 === 0 ? '' : '#e0ffff' }} >{rec.cscd}
                  </td>
                  <td style={{ background: index % 2 === 0 ? '' : '#e0ffff' }} >{rec.judcmtstc}
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


export default PrepaInfoCmntHisBody;
