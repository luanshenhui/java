import React from 'react';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router-dom';
import { Field, reduxForm, blur } from 'redux-form';
import { connect } from 'react-redux';
import moment from 'moment';
import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import DatePicker from '../../../components/control/datepicker/DatePicker';
import DropDownRsvGrp from '../../../components/control/dropdown/DropDownRsvGrp';
import DropDownCourseRsvGrp from '../../../components/control/dropdown/DropDownCourseRsvGrp';
import Button from '../../../components/control/Button';
import Label from '../../../components/control/Label';
import RsvFraEditGuide from './RsvFraEditGuide';
import { getRsvFraListRequest, initializeRsvFraList, openRsvFraInsertGuide } from '../../../modules/preference/scheduleModule';

const formName = 'RsvFraSearchHeader';
class RsvFraSearchHeader extends React.Component {
  constructor(props) {
    super(props);
    this.handleActionClick = this.handleActionClick.bind(this);
  }

  componentWillMount() {
    const { onLoad } = this.props;
    onLoad();
  }

  // 表示ボタンをクリックする処理
  handleActionClick(values) {
    const { onSearch } = this.props;
    onSearch(values);
  }

  render() {
    const { rsvFraEditInsertClick, initialValues, handleSubmit } = this.props;
    return (
      <div>
        <form>
          <FieldGroup itemWidth={120}>
            <FieldSet>
              <FieldItem>受診日範囲</FieldItem>
              <Field name="startcsldate" component={DatePicker} id="startdate" />
              <Label>～</Label>
              <Field name="endcsldate" component={DatePicker} id="enddate" />
            </FieldSet>
            <FieldSet>
              <FieldItem>コースコード</FieldItem>
              <Field name="cscd" component={DropDownCourseRsvGrp} addblank id="cscd" />
            </FieldSet>
            <FieldSet>
              <FieldItem>予約群</FieldItem>
              <Field name="rsvgrpcd" component={DropDownRsvGrp} addblank id="rsvgrpcd" />
            </FieldSet>
            <FieldSet>
              <Button type="submit" value="検索" onClick={handleSubmit((values) => this.handleActionClick(values))} />
              <Button onClick={() => { rsvFraEditInsertClick(); }} value="新規" />
            </FieldSet>
          </FieldGroup>
        </form>
        <RsvFraEditGuide conditions={initialValues} />
      </div>
    );
  }
}

// propTypesの定義
RsvFraSearchHeader.propTypes = {
  rsvFraEditInsertClick: PropTypes.func.isRequired,
  initialValues: PropTypes.shape().isRequired,
  handleSubmit: PropTypes.func.isRequired,
  onSearch: PropTypes.func.isRequired,
  onLoad: PropTypes.func.isRequired,
};

const RsvFraSearchHeaderForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(RsvFraSearchHeader);


const mapStateToProps = (state) => ({
  initialValues: {
    startcsldate: state.app.preference.schedule.rsvfraList.conditions.startcsldate,
    endcsldate: state.app.preference.schedule.rsvfraList.conditions.endcsldate,
    cscd: state.app.preference.schedule.rsvfraList.conditions.cscd,
    rsvgrpcd: state.app.preference.schedule.rsvfraList.conditions.rsvgrpcd,
  },
});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onSearch: (conditions) => {
    const { startcsldate, endcsldate } = conditions;
    const wsdate = (!startcsldate || startcsldate === '' ? moment(new Date()).format('YYYY/MM/DD') : startcsldate);
    const wedate = (!endcsldate || endcsldate === '' ? moment(new Date()).format('YYYY/MM/DD') : endcsldate);

    dispatch(blur(formName, 'startcsldate', wsdate));
    dispatch(blur(formName, 'endcsldate', wedate));
    dispatch(getRsvFraListRequest({ ...conditions, startcsldate: wsdate, endcsldate: wedate }));
  },
  onLoad: () => {
    dispatch(initializeRsvFraList());
  },
  rsvFraEditInsertClick: () => {
    dispatch(openRsvFraInsertGuide());
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(RsvFraSearchHeaderForm));
