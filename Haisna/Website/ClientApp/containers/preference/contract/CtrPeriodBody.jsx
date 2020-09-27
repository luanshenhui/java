import React from 'react';
import PropTypes from 'prop-types';
import { Field } from 'redux-form';
import styled from 'styled-components';
import moment from 'moment';
import Table from '../../../components/Table';
import BulletedLabel from '../../../components/control/BulletedLabel';
import DatePicker from '../../../components/control/datepicker/DatePicker';
import LabelOrgName from '../../../components/control/label/LabelOrgName';
import LabelCourse from '../../../components/control/label/LabelCourse';
import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import Label from '../../../components/control/Label';

const WrapperBulleted = styled.div`
  .bullet { color: #cc9999 };
`;

const getDtmArrDate = (rec, ctrptcd) => {
  const res = [];
  let date;
  if (rec.ctrptcd !== ctrptcd) {
    date = (
      <tr key={`period-${rec.strdate}-${rec.enddate}`}>
        <td>{moment(rec.strdate).format('YYYY/MM/DD')}～{moment(rec.enddate).format('YYYY/MM/DD')}</td>
      </tr>);
    res.push(date);
  }
  return res;
};

const showDtmArrDate = (data, ctrptcd) => {
  let res = false;
  for (let i = 0; i < data.length; i += 1) {
    if (data[i].ctrptcd !== ctrptcd) {
      res = true;
    }
  }
  return res;
};

const CtrPeriodBody = ({ courseHistoryData, dtmArrDate, params, newmode }) => (
  <div>
    <FieldGroup itemWidth={100}>
      <FieldSet>
        <FieldItem>契約団体</FieldItem>
        <LabelOrgName orgcd1={params.orgcd1} orgcd2={params.orgcd2} />
      </FieldSet>
      <FieldSet>
        <FieldItem>対象コース</FieldItem>
        <LabelCourse cscd={params.cscd} />
      </FieldSet>
      <FieldSet>
        <WrapperBulleted><BulletedLabel>契約期間を指定して下さい。</BulletedLabel></WrapperBulleted>
      </FieldSet>
      <FieldSet>
        <WrapperBulleted><BulletedLabel>すでに登録されている契約情報の契約期間にまたがる日付指定はできません。</BulletedLabel></WrapperBulleted>
      </FieldSet>
    </FieldGroup>
    <FieldGroup itemWidth={100}>
      <FieldSet>
        <FieldItem>契約開始日</FieldItem>
        <Field name="strdate" component={DatePicker} id="strdate" />
      </FieldSet>
      <FieldSet>
        <FieldItem>契約終了日</FieldItem>
        <Field name="enddate" component={DatePicker} id="enddate" />
      </FieldSet>
    </FieldGroup>
    <div>&nbsp;</div>
    {dtmArrDate && showDtmArrDate(dtmArrDate, Number(params.ctrptcd)) &&
      <FieldGroup>
        <FieldSet>
          <LabelCourse cscd={params.cscd} /><Label>の{(newmode ? '現在' : 'その他')}の契約情報：</Label>
        </FieldSet>
        <FieldSet>
          <Table style={{ width: '35%' }}>
            <thead>
              <tr bgcolor="#cccccc">
                <th>契約期間</th>
              </tr>
            </thead>
            <tbody>
              {dtmArrDate.map((rec) => (
                getDtmArrDate(rec, Number(params.ctrptcd))
              ))}
            </tbody>
          </Table>
        </FieldSet>
      </FieldGroup>
    }
    {!(showDtmArrDate(dtmArrDate, Number(params.ctrptcd))) &&
      <FieldGroup>
        <FieldSet>
          <LabelCourse cscd={params.cscd} /><Label>の{(newmode ? '現在' : 'その他')}の契約情報：</Label><Label>なし</Label>
        </FieldSet>
      </FieldGroup>
    }
    <div>&nbsp;</div>
    <Table style={{ width: '35%' }}>
      <thead>
        <tr>
          <th>コースの履歴：</th>
        </tr>
        <tr bgcolor="#cccccc" style={{ height: '22px', width: '219px' }}>
          <th>適用期間</th>
        </tr>
      </thead>
      <tbody>
        {courseHistoryData && courseHistoryData.map((rec) => (
          <tr key={`course-${rec.strdate}-${rec.enddate}`}>
            <td>{moment(rec.strdate).format('YYYY/MM/DD')}
              ～{moment(rec.enddate).format('YYYY/MM/DD')}
            </td>
          </tr>
        ))}
      </tbody>
    </Table>
  </div>
);

// propTypesの定義
CtrPeriodBody.propTypes = {
  dtmArrDate: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  courseHistoryData: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  params: PropTypes.shape(),
  newmode: PropTypes.bool,
};

CtrPeriodBody.defaultProps = {
  params: {},
  newmode: false,
};

export default CtrPeriodBody;
