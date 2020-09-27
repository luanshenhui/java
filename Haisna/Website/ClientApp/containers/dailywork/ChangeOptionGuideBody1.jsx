import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import Table from '../../components/Table';
import LabelCourseWebColor from '../../components/control/label/LabelCourseWebColor';

const Wrapper = styled.div`
  white-space: nowrap;
`;

const EditSet = (data) => {
  const { optfromconsultdata, optiondata } = data;
  const res = [];
  const arrConsult = [];
  const optcd = [];
  const optbranchno = [];
  const arroptcd = [];
  const arroptbranchno = [];
  const setcolor = [];
  const optname = [];
  const hidequestion = [];
  let resSetList = [];
  let blnconsult = false;
  let optcount = 0;
  let count = 0;

  while (optcount < optiondata.length && optiondata.length > 0) {
    optcd[optcount] = optiondata[optcount].optcd;
    optbranchno[optcount] = optiondata[optcount].optbranchno;
    optcount += 1;
  }

  while (count < optfromconsultdata.length && optfromconsultdata.length > 0) {
    arroptbranchno[count] = optfromconsultdata[count].optbranchno;
    arroptcd[count] = optfromconsultdata[count].optcd;
    setcolor[count] = optfromconsultdata[count].setcolor;
    optname[count] = optfromconsultdata[count].optname;
    hidequestion[count] = optfromconsultdata[count].hidequestion;
    count += 1;
  }

  if (optcd.length > 0) {
    for (let n = 0; n < optcd.length; n += 1) {
      arrConsult[n] = '1';
    }
  }

  // 読み込んだオプション検査情報の検索
  if (optfromconsultdata.length > 0) {
    for (let i = 0; i < optfromconsultdata.length; i += 1) {
      resSetList = [];
      blnconsult = false;
      if (hidequestion[i] === null) {
        // 引数指定時
        if (optcd.length > 0 && optbranchno.length > 0) {
          for (let j = 0; j < optcd.length; j += 1) {
            if (optcd[j] === arroptcd[i] && optbranchno[j] === arroptbranchno[i] && arrConsult[i] === '1') {
              blnconsult = true;
              break;
            }
          }
        }
        resSetList.push(blnconsult === true ? <td style={{ border: '0px' }} key={i + 1}>○</td> : <td style={{ border: '0px' }} key={i + 1}>&nbsp;</td>);
        resSetList.push(<td style={{ border: '0px' }} key={i + 2}><Wrapper>{arroptcd[i]}</Wrapper></td>);
        resSetList.push(<td style={{ border: '0px' }} key={i + 3}><Wrapper>-{arroptbranchno[i]}</Wrapper></td>);
        resSetList.push(<td style={{ border: '0px' }} key={i + 4}>:</td>);
        resSetList.push(<td style={{ border: '0px' }} key={i + 5}><Wrapper><LabelCourseWebColor webcolor={setcolor[i]}>■</LabelCourseWebColor>{optname[i]}</Wrapper></td>);
      }
      if (resSetList.length > 0) {
        res.push(<tr style={{ background: 'white', height: '15px', fontSize: '13px' }} key={i}>{resSetList}</tr>);
      }
    }
  }
  return res;
};

const ChangeOptionGuideBody1 = ({ optfromconsultdata, optiondata }) => (
  <div>
    <Table >
      <thead>
        <tr>
          <td style={{ height: '15px', fontSize: '13px', background: '#e0e0e0', border: '0px' }} align="center" colSpan="5" >検査セット名</td>
        </tr>
      </thead>
      <tbody>
        <EditSet optfromconsultdata={optfromconsultdata} optiondata={optiondata} />
      </tbody>
    </Table>
  </div>
);

// propTypesの定義
ChangeOptionGuideBody1.propTypes = {
  optfromconsultdata: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  optiondata: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

export default ChangeOptionGuideBody1;
