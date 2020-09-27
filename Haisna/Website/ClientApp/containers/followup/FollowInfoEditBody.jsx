import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import styled from 'styled-components';

import Button from '../../components/control/Button';

const SeccslDate = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const webTestItem = (followRslList) => {
  let strWebTestItem = '';
  let testCount = 0;
  if (followRslList.testus === 1) {
    strWebTestItem += 'US  ';
    testCount += 1;
  }
  if (followRslList.testct === 1) {
    if (testCount > 0) {
      strWebTestItem += '/  CT  ';
    } else {
      strWebTestItem += 'CT  ';
    }
    testCount += 1;
  }
  if (followRslList.testmri === 1) {
    if (testCount > 0) {
      strWebTestItem += '/  MRI  ';
    } else {
      strWebTestItem += 'MRI  ';
    }
    testCount += 1;
  }
  if (followRslList.testbf === 1) {
    if (testCount > 0) {
      strWebTestItem += '/  BF  ';
    } else {
      strWebTestItem += 'BF  ';
    }
    testCount += 1;
  }
  if (followRslList.testgf === 1) {
    if (testCount > 0) {
      strWebTestItem += '/  GF  ';
    } else {
      strWebTestItem += 'GF  ';
    }
    testCount += 1;
  }
  if (followRslList.testcf === 1) {
    if (testCount > 0) {
      strWebTestItem += '/  CF  ';
    } else {
      strWebTestItem += 'CF  ';
    }
    testCount += 1;
  }
  if (followRslList.testem === 1) {
    if (testCount > 0) {
      strWebTestItem += '/  注腸  ';
    } else {
      strWebTestItem += '注腸  ';
    }
    testCount += 1;
  }
  if (followRslList.testtm === 1) {
    if (testCount > 0) {
      strWebTestItem += '/  腫瘍マーカー  ';
    } else {
      strWebTestItem += '腫瘍マーカー  ';
    }
    testCount += 1;
  }
  if (followRslList.testrefer === 1) {
    if (testCount > 0) {
      strWebTestItem += '/  リファー  ';
    } else {
      strWebTestItem += 'リファー  ';
    }
    if (followRslList.testrefertext !== null) {
      strWebTestItem += `( ${followRslList.testrefertext} )`;
    }
  }
  if (followRslList.testetc === 1) {
    if (testCount > 0) {
      strWebTestItem += '/  その他 ';
    } else {
      strWebTestItem += 'その他  ';
    }
    if (followRslList.testremark !== null) {
      strWebTestItem += `( ${followRslList.testremark} )`;
    }
  }
  return strWebTestItem;
};

const webResultDivName = (resultDiv) => {
  let strWebResultDivName;
  switch (resultDiv) {
    case 1:
      strWebResultDivName = '異常なし';
      break;
    case 2:
      strWebResultDivName = '不明';
      break;
    case 3:
      strWebResultDivName = '診断名あり';
      break;
    default:
      break;
  }
  return strWebResultDivName;
};

const webPolicy1 = (followRslList) => {
  let strWebPolicy1 = '';
  let polCount2 = 0;
  if (followRslList.polwithout === 1) {
    strWebPolicy1 += '処置不要  ';
    polCount2 += 1;
  }
  if (followRslList.polfollowup === 1) {
    if (polCount2 > 0) {
      strWebPolicy1 += '/  経過観察 ';
    } else {
      strWebPolicy1 += '経過観察 ';
    }
    if (followRslList.polmonth !== null) {
      strWebPolicy1 += `( ${followRslList.polmonth} ヶ月 )  `;
    } else {
      strWebPolicy1 += ' ';
    }
    polCount2 += 1;
  }
  if (followRslList.polreexam === 1) {
    if (polCount2 > 0) {
      strWebPolicy1 += '/  1年後健診  ';
    } else {
      strWebPolicy1 += '1年後健診  ';
    }
    polCount2 += 1;
  }
  if (followRslList.poldiagst === 1) {
    if (polCount2 > 0) {
      strWebPolicy1 += '/  本院・メディローカス紹介（精査）  ';
    } else {
      strWebPolicy1 += '本院・メディローカス紹介（精査）  ';
    }
    polCount2 += 1;
  }
  if (followRslList.poldiag === 1) {
    if (polCount2 > 0) {
      strWebPolicy1 += '/  他院紹介（精査）  ';
    } else {
      strWebPolicy1 += '他院紹介（精査）  ';
    }
    polCount2 += 1;
  }
  if (followRslList.poletc1 === 1) {
    if (polCount2 > 0) {
      strWebPolicy1 += '/  その他 ';
    } else {
      strWebPolicy1 += 'その他 ';
    }
    if (followRslList.polremark1 !== null) {
      strWebPolicy1 += `( ${followRslList.polremark1} ) `;
    }
  }
  return strWebPolicy1;
};

const webPolicy2 = (followRslList) => {
  let strWebPolicy2 = '';
  let polCount2 = 0;
  if (followRslList.polsugery === 1) {
    strWebPolicy2 += '外科治療    ';
    polCount2 += 1;
  }
  if (followRslList.polendoscope === 1) {
    if (polCount2 > 0) {
      strWebPolicy2 += '/  内視鏡的治療  ';
    } else {
      strWebPolicy2 += '内視鏡的治療  ';
    }
    polCount2 += 1;
  }
  if (followRslList.polchemical === 1) {
    if (polCount2 > 0) {
      strWebPolicy2 += '/  化学療法  ';
    } else {
      strWebPolicy2 += '化学療法  ';
    }
    polCount2 += 1;
  }
  if (followRslList.polradiation === 1) {
    if (polCount2 > 0) {
      strWebPolicy2 += '/  放射線治療  ';
    } else {
      strWebPolicy2 += '放射線治療  ';
    }
    polCount2 += 1;
  }
  if (followRslList.polreferst === 1) {
    if (polCount2 > 0) {
      strWebPolicy2 += '/  本院・メディローカス紹介  ';
    } else {
      strWebPolicy2 += '本院・メディローカス紹介  ';
    }
    polCount2 += 1;
  }
  if (followRslList.polrefer === 1) {
    if (polCount2 > 0) {
      strWebPolicy2 += '/  他院紹介  ';
    } else {
      strWebPolicy2 += '他院紹介  ';
    }
    polCount2 += 1;
  }
  if (followRslList.poletc2 === 1) {
    if (polCount2 > 0) {
      strWebPolicy2 += '/  その他 ';
    } else {
      strWebPolicy2 += 'その他 ';
    }
    if (followRslList.polremark2 !== null) {
      strWebPolicy2 += `( ${followRslList.polremark2} ) `;
    }
  }
  return strWebPolicy2;
};

const FollowInfoEditBody = ({ followInfo, count, followRslList, followRslItemList, onShowFollowRsl }) => (
  <table style={{ backgroundColor: '#999999', width: '95%', height: 200 }}>
    <tbody>
      <tr>
        <td style={{ backgroundColor: '#ffffff', width: '100%' }}>
          <table>
            <tbody>
              <tr>
                <td style={{ whiteSpace: 'pre', width: 120, backgroundColor: '#cccccc' }}>&nbsp;検査（治療）実施日</td>
                <td>
                  <table>
                    <tbody>
                      <tr>
                        <td style={{ whiteSpace: 'pre', width: 150 }}><SeccslDate>{moment(followRslList[count].seccsldate).format('M/D/YYYY')}</SeccslDate></td>
                        {followInfo && followInfo.reqconfirmdate === null &&
                          <Button
                            style={{ marginLeft: '50px' }}
                            onClick={() => { onShowFollowRsl(followRslList[count].rsvno, followRslList[count].judclasscd, followRslList[count].seq); }}
                            value="変更"
                          />
                        }
                      </tr>
                    </tbody>
                  </table>
                </td>
              </tr>
              <tr>
                <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc' }}>&nbsp;二次検査項目</td>
                <td>
                  <table>
                    <tbody>
                      <tr>
                        <td>{webTestItem(followRslList[count])}</td>
                      </tr>
                    </tbody>
                  </table>
                </td>
              </tr>
              <tr>
                <td style={{ width: 120, whiteSpace: 'pre', backgroundColor: '#cccccc' }}>&nbsp;二次検査結果</td>
                <td>
                  <table>
                    <tbody>
                      <tr>
                        <td>{webResultDivName(followRslList[count].resultdiv)}</td>
                      </tr>
                    </tbody>
                  </table>
                </td>
              </tr>
              <tr>
                <td style={{ width: 120, whiteSpace: 'pre', backgroundColor: '#cccccc' }}>&nbsp;診断名</td>
                <td style={{ width: '100%' }}>
                  <table style={{ backgroundColor: '#999999', width: '100%' }}>
                    <tbody>
                      <tr style={{ backgroundColor: '#cccccc', textAlign: 'center' }}>
                        <td style={{ width: 130, whiteSpace: 'pre' }}>分類</td>
                        <td style={{ width: 160, whiteSpace: 'pre' }}>臓器（部位）</td>
                        <td style={{ whiteSpace: 'pre' }}>診断名</td>
                      </tr>
                      {followRslItemList[count] && followRslItemList[count].map((rec) => (
                        <tr key={rec.key} style={{ backgroundColor: '#ffffff', textAlign: 'left' }}>
                          <td style={{ width: 130, whwhiteSpace: 'pre' }}>{rec.grpname}</td>
                          <td style={{ width: 160, whiteSpace: 'pre' }}>{rec.itemname}</td>
                          <td style={{ whiteSpace: 'pre' }}>{rec.shortstc}</td>
                        </tr>
                      ))}
                      {followRslItemList[count].length === 0 &&
                        <tr style={{ backgroundColor: '#ffffff', textAlign: 'center' }}>
                          <td style={{ whiteSpace: 'pre' }} colSpan="3">登録されている診断名がありません。</td>
                        </tr>
                      }
                    </tbody>
                  </table>
                </td>
              </tr>
              <tr>
                <td style={{ width: 120, whiteSpace: 'pre', backgroundColor: '#cccccc' }}>&nbsp;その他疾患</td>
                <td>
                  <table>
                    <tbody>
                      <tr>
                        <td><pre>{followRslList[count].disremark}</pre></td>
                      </tr>
                    </tbody>
                  </table>
                </td>
              </tr>
              <tr>
                <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc' }}>&nbsp;方針（治療なし）</td>
                <td>
                  <table>
                    <tbody>
                      <tr>
                        <td>{webPolicy1(followRslList[count])}</td>
                      </tr>
                    </tbody>
                  </table>
                </td>
              </tr>
              <tr>
                <td style={{ whiteSpace: 'pre', backgroundColor: '#cccccc' }}>&nbsp;方針（治療あり）</td>
                <td>
                  <table>
                    <tbody>
                      <tr>
                        <td>{webPolicy2(followRslList[count])}</td>
                      </tr>
                    </tbody>
                  </table>
                </td>
              </tr>
            </tbody>
          </table>
        </td>
      </tr>
    </tbody>
  </table>
);

// propTypesの定義
FollowInfoEditBody.propTypes = {
  count: PropTypes.number.isRequired,
  followInfo: PropTypes.shape().isRequired,
  followRslList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  followRslItemList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onShowFollowRsl: PropTypes.func.isRequired,
};

export default FollowInfoEditBody;

