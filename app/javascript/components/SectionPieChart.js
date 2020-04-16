import ReactOnRails from 'react-on-rails';
import React from 'react';
import { ResponsivePie } from '@nivo/pie'

class SectionPieChart extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    const section_data = this.props.data;
    const data = [
      {
        "id": `Correct [${section_data.correct}]`,
        "label": "correct",
        "value": section_data.correct,
        "color": "rgb(2, 160, 0)"
      },
      {
        "id": `Wrong [${section_data.incorrect}]`,
        "label": "wrong",
        "value": section_data.incorrect,
        "color": "rgb(195, 0, 0)"
      },
      {
        "id": `Not Sovled [${section_data.not_answered}]`,
        "label": "not_solved",
        "value": section_data.not_answered,
        "color": "gray"
      }
    ];

    return(
      <div>
        <table class="table table-sm table-bordered">
          <tbody>
            <tr>
              <td colspan="3">
                <button type="button" class="btn btn-outline-info btn-sm">{ section_data.section_name && section_data.section_name.toUpperCase() }</button>
                <div style={{height: 300}}>
                  <ResponsivePie
                    data={data}
                    margin={{ top: 0, right: 80, bottom: 60, left: 80 }}
                    innerRadius={0.5}
                    padAngle={1.9}
                    cornerRadius={3}
                    colors={d => d.color}
                    borderWidth={1}
                    borderColor={{ from: 'color', modifiers: [ [ 'darker', 0.2 ] ] }}
                    radialLabelsSkipAngle={10}
                    radialLabelsTextXOffset={6}
                    radialLabelsTextColor="#333333"
                    radialLabelsLinkOffset={0}
                    radialLabelsLinkDiagonalLength={16}
                    radialLabelsLinkHorizontalLength={24}
                    radialLabelsLinkStrokeWidth={1}
                    radialLabelsLinkColor={{ from: 'color' }}
                    slicesLabelsSkipAngle={10}
                    slicesLabelsTextColor="#333333"
                    animate={true}
                    motionStiffness={90}
                    motionDamping={15}
                    defs={[
                        {
                            id: 'dots',
                            type: 'patternDots',
                            background: 'inherit',
                            color: 'rgba(255, 255, 255, 0.3)',
                            size: 4,
                            padding: 1,
                            stagger: true
                        },
                        {
                            id: 'lines',
                            type: 'patternLines',
                            background: 'inherit',
                            color: 'rgba(255, 255, 255, 0.3)',
                            rotation: -45,
                            lineWidth: 6,
                            spacing: 10
                        }
                    ]}
                    fill={[
                      {
                          match: {
                              id: 'correct'
                          },
                          id: 'dots'
                      }
                    ]}
                    legends={[
                        {
                            anchor: 'bottom',
                            direction: 'row',
                            translateY: 20,
                            itemWidth: 100,
                            itemHeight: 18,
                            itemTextColor: '#999',
                            symbolSize: 18,
                            symbolShape: 'circle',
                            effects: [
                                {
                                    on: 'hover',
                                    style: {
                                        itemTextColor: '#000'
                                    }
                                }
                            ]
                        }
                    ]}
                  />
                </div>
              </td>
            </tr>
            <tr>
              <td>Score: </td>
              <td>
                <h5>{`${section_data.score} / ${(section_data.total_question * 4)}`}</h5>
              </td>
              <td>
                Topper: <span class="badge badge-warning">{section_data.topper_score}</span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    )
  }
}

export default SectionPieChart;